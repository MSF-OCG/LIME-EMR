#!/usr/bin/env bash

function setMSFEnvironment {
    echo "$INFO Adding MSF environment variables"
    export OPENFN_CONFIG_PATH=$DISTRO_PATH/configs/openfn
    echo "→ OPENFN_CONFIG_PATH=$OPENFN_CONFIG_PATH"

    export OPENFN_HOSTNAME="localhost:4000"
    echo "→ OPENFN_HOSTNAME=$OPENFN_HOSTNAME"
    
    export TRAEFIK_CONFIG_PATH=$DISTRO_PATH/configs/traefik
    echo "→ TRAEFIK_CONFIG_PATH=$TRAEFIK_CONFIG_PATH"

    # ignore setting nginx since traefik is not enabled
    if [ "$TRAEFIK" == "true" ]; then
        echo "$INFO \$TRAEFIK=true, Exporting MSF Nginx hostnames..."
        echo "TRAEFIK_PUBLIC_PORT=8090" >> ../.env
        export OPENFN_LOCAL_HOSTNAME="localhost:4000"
        echo "→ OPENFN_LOCAL_HOSTNAME=$OPENFN_LOCAL_HOSTNAME"

        export O3_LOCAL_HOSTNAME="localhost:4001"
        echo "→ O3_LOCAL_HOSTNAME=$O3_LOCAL_HOSTNAME"
        setNginxHostnames
    fi
}

function displayMSFAccessURLsWithCredentials {
    # ignore setting nginx since traefik is not enabled
    if [ "$TRAEFIK" != "true" ]; then
        return 0
    fi

    services=()
    is_defined=()

    # Read docker-compose-files.txt and extract the list of services run
    while read -r line; do
        serviceWithoutExtension=${line%.yml}
        service=${serviceWithoutExtension#docker-compose-}
        
        services+=("$service")
        is_defined+=(1)
    done < docker-compose-files.txt

    echo "HIS Component,URL,Username,Password" > .urls_1.txt
    echo "-,-,-,-" >> .urls_1.txt
    tail -n +2 msf-urls-template.csv | while IFS=',' read -r component url username password service ; do
        for i in "${!services[@]}"; do
            if [[ "${services[$i]}" == "$service" && "${is_defined[$i]}" == 1 ]]; then
                echo "$component,$url,$username,$password" >> .urls_1.txt
                break
            fi
        done
    done

    envsubst < .urls_1.txt > .urls_2.txt
    echo ""
    echo "==========================================================="
    echo "$INFO On Localhost "
    echo "==========================================================="
    echo ""

    set +e
    column -t -s ',' .urls_2.txt > .urls_3.txt 2> /dev/null
    set -e
    cat .urls_3.txt
}

function runMSFServerTraefikAndNginxProxy {
    echo "$INFO Running Nginx proxy service (\$TRAEFIK=true)..."
    dockerComposeProxyCommand="docker compose -p $PROJECT_NAME $dockerComposeProxyCLIOptions up -d --build"
    echo ""
    echo "$dockerComposeProxyCommand"
    echo ""
    ($dockerComposeProxyCommand)

    echo "$INFO Running Traefik... (\$TRAEFIK=true)"
    export dockerComposeTraefikCLIOptions="--env-file $dockerComposeEnvFilePath -f ../docker-compose-traefik.yml"
    dockerComposeTraefikCommand="docker compose -p $PROJECT_NAME $dockerComposeTraefikCLIOptions up -d --build"
    echo "$INFO Running Traefik service (\$TRAEFIK!=true)..."
    echo ""
    echo "$dockerComposeTraefikCommand"
    echo ""
    ($dockerComposeTraefikCommand)
}

function waitForHealthy {
    local container=$1
    local maxWait=${2:-60}
    local elapsed=0
    echo "$INFO Waiting for $container to be healthy..."
    while [ "$elapsed" -lt "$maxWait" ]; do
        local status
        status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)
        if [ "$status" == "healthy" ]; then
            echo "$INFO $container is healthy (${elapsed}s)"
            return 0
        fi
        sleep 2
        elapsed=$((elapsed + 2))
    done
    echo "$ERROR Timed out waiting for $container to become healthy (${maxWait}s)"
    return 1
}

function migrateOpenfnDatabase {
    local oldPgContainer="${PROJECT_NAME}-postgresql-1"
    local newPgContainer="${PROJECT_NAME}-openfn-postgresql-1"
    local dbName="${OPENFN_DB_NAME:-lightning_prod}"
    local dbUser="${OPENFN_DB_USER:-hello}"
    local sharedPgUser="${POSTGRES_USER:-postgres}"

    echo "$INFO Checking whether OpenFn database migration is needed..."

    local oldDbExists
    oldDbExists=$(docker exec "$oldPgContainer" psql -U "$sharedPgUser" -tAc \
        "SELECT 1 FROM pg_database WHERE datname='$dbName'" 2>/dev/null | tr -d '[:space:]')

    if [ "$oldDbExists" != "1" ]; then
        echo "$INFO No OpenFn database ('$dbName') in shared PostgreSQL — fresh install, skipping migration"
        return 0
    fi

    local oldTableCount
    oldTableCount=$(docker exec "$oldPgContainer" psql -U "$sharedPgUser" -d "$dbName" -tAc \
        "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public'" 2>/dev/null | tr -d '[:space:]')

    if [ -z "$oldTableCount" ] || [ "$oldTableCount" -eq 0 ] 2>/dev/null; then
        echo "$INFO OpenFn database in shared PostgreSQL has no tables — skipping migration"
        return 0
    fi

    local newTableCount
    newTableCount=$(docker exec "$newPgContainer" psql -U "$dbUser" -d "$dbName" -tAc \
        "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public'" 2>/dev/null | tr -d '[:space:]')

    if [ -n "$newTableCount" ] && [ "$newTableCount" -gt 0 ] 2>/dev/null; then
        echo "$INFO Dedicated OpenFn PostgreSQL already has $newTableCount tables — skipping migration"
        return 0
    fi

    echo "$INFO Migrating OpenFn database from shared PostgreSQL to dedicated PostgreSQL 16..."
    echo "$INFO Source: $oldPgContainer ($oldTableCount tables)  →  Target: $newPgContainer"

    local dumpfile
    dumpfile=$(mktemp)
    # shellcheck disable=SC2064
    trap 'rm -f "$dumpfile"' RETURN

    if ! docker exec "$oldPgContainer" pg_dump -U "$sharedPgUser" -d "$dbName" --no-owner --no-acl >"$dumpfile" 2>/dev/null; then
        echo "$ERROR OpenFn database migration failed (pg_dump)"
        return 1
    fi
    if ! docker exec -i "$newPgContainer" psql -U "$dbUser" -d "$dbName" -q <"$dumpfile" 2>/dev/null; then
        echo "$ERROR OpenFn database migration failed (restore)"
        return 1
    fi

    local verifyCount
    verifyCount=$(docker exec "$newPgContainer" psql -U "$dbUser" -d "$dbName" -tAc \
        "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public'" 2>/dev/null | tr -d '[:space:]')
    echo "$INFO Migration complete — $verifyCount tables in dedicated PostgreSQL 16"
}

function startMSFPostgreSQLAndMigrateOpenfn {
    if [ -f "../concatenated.env" ]; then
        set -a
        # shellcheck disable=SC1091
        source "../concatenated.env"
        set +a
    elif [ -f "../.env" ]; then
        set -a
        # shellcheck disable=SC1091
        source "../.env"
        set +a
    fi

    echo "$INFO Starting database containers (shared PostgreSQL + dedicated OpenFn PostgreSQL 16)..."
    docker network inspect web >/dev/null 2>&1 || docker network create web

    docker compose -p "$PROJECT_NAME" $dockerComposeOzoneCLIOptions up -d --pull always postgresql openfn-postgresql

    waitForHealthy "${PROJECT_NAME}-postgresql-1" 60
    waitForHealthy "${PROJECT_NAME}-openfn-postgresql-1" 60

    migrateOpenfnDatabase
}
