#!/usr/bin/env bash
# Load OpenFn collection metadata from a GitHub-hosted JSON file (issue #250).
# Non-fatal: logs errors and returns without stopping the parent deployment.

load_openfn_collections() {
    if [ -z "${OPENFN_COLLECTIONS_JSON_URL:-}" ]; then
        echo "$INFO OPENFN_COLLECTIONS_JSON_URL not set. Skipping OpenFn collections load."
        return 0
    fi

    local collection_name="${OPENFN_COLLECTION_NAME:-mosul-metadata-mappings-staging}"
    local openfn_endpoint="${OPENFN_ENDPOINT:-http://web:4000}"
    local openfn_api_key="${OPENFN_API_KEY:-${MSF_OPENFN_PAT:-}}"
    local github_token="${OPENFN_COLLECTIONS_GITHUB_TOKEN:-}"
    local json_url="${OPENFN_COLLECTIONS_JSON_URL}"
    local worker_container="${PROJECT_NAME}-worker-1"
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if [ -z "$openfn_api_key" ]; then
        echo "$ERROR OPENFN_API_KEY (or MSF_OPENFN_PAT) is required to load collections. Skipping."
        return 0
    fi

    # GitHub blob URLs must be converted to raw content URLs.
    case "$json_url" in
        *github.com/*/blob/*)
            json_url="${json_url/github.com\/raw.githubusercontent.com}"
            json_url="${json_url/\/blob\//\/}"
            ;;
    esac

    echo "$INFO Loading OpenFn collection '${collection_name}' from GitHub JSON..."

    local tmp_dir
    tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/lime-openfn-collections.XXXXXX")"
    local source_json="${tmp_dir}/collections-source.json"
    local batches_dir="${tmp_dir}/batches"
    local curl_auth=()

    if [ -n "$github_token" ]; then
        curl_auth=(-H "Authorization: Bearer ${github_token}")
    fi

    if ! curl -fsSL "${curl_auth[@]}" -o "$source_json" "$json_url"; then
        echo "$ERROR Failed to download collections JSON from ${json_url}. Skipping collections load."
        rm -rf "$tmp_dir"
        return 0
    fi

    if ! python3 "${script_dir}/prepare_openfn_collection_batches.py" \
        "$source_json" "$batches_dir"; then
        echo "$ERROR Failed to prepare collection upload batches. Skipping collections load."
        rm -rf "$tmp_dir"
        return 0
    fi

    local batch_count
    batch_count="$(find "$batches_dir" -name 'batch-*.json' | wc -l | tr -d ' ')"
    if [ "$batch_count" -eq 0 ]; then
        echo "$ERROR No collection batches produced from source JSON. Skipping."
        rm -rf "$tmp_dir"
        return 0
    fi

    docker cp "$batches_dir" "${worker_container}:/tmp/openfn-collection-batches" || {
        echo "$ERROR Failed to copy collection batches to worker container. Skipping."
        rm -rf "$tmp_dir"
        return 0
    }

    (
        set +e
        docker exec "$worker_container" sh -c "
            set -e
            export OPENFN_API_KEY='${openfn_api_key}'
            export OPENFN_ENDPOINT='${openfn_endpoint}'
            cd /app/packages/ws-worker/lime

            if ! openfn collections get '${collection_name}' '*' -o /tmp/collection-check.json >/dev/null 2>&1; then
                echo 'Collection ${collection_name} not found.'
                echo 'Create it via collections: in your openfn-project.yaml, then re-run openfn deploy.'
                exit 1
            fi

            echo 'Clearing existing collection items...'
            openfn collections remove '${collection_name}' '*' || exit 1

            for batch in /tmp/openfn-collection-batches/batch-*.json; do
                echo \"Uploading \${batch}...\"
                openfn collections set '${collection_name}' --items \"\${batch}\" || exit 1
            done
        "
        load_status=$?
    )

    docker exec "$worker_container" rm -rf /tmp/openfn-collection-batches >/dev/null 2>&1 || true
    rm -rf "$tmp_dir"

    if [ "$load_status" -eq 0 ]; then
        echo "$INFO OpenFn collection '${collection_name}' loaded successfully (${batch_count} batch(es))."
    else
        echo "$ERROR OpenFn collection load failed. Deployment continues."
    fi

    return 0
}
