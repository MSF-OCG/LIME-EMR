#!/usr/bin/env bash

function setMSFEnvironment {
    echo "$INFO Adding OpenFn environment versions"
    export TRAEFIK_CONFIG_PATH=$DISTRO_PATH/configs/traefik
    echo "→ TRAEFIK_CONFIG_PATH=$TRAEFIK_CONFIG_PATH"

    export OPENFN_HOSTNAME="localhost:4000"
    echo "→ OPENFN_HOSTNAME=$OPENFN_HOSTNAME"

    # ignore setting nginx since traefik is not enabled
    if [ "$TRAEFIK" == "true" ]; then
        echo "$INFO \$TRAEFIK=true, Exporting MSF Nginx hostnames..."
        echo "TRAEFIK_PUBLIC_PORT=8090" >> ../.env
        export OPENFN_LOCAL_HOSTNAME="localhost:4000"
        echo "→ OPENFN_LOCAL_HOSTNAME=$OPENFN_LOCAL_HOSTNAME"

        export O3_LOCAL_HOSTNAME="localhost"
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
