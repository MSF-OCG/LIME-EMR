#!/bin/bash

local backend_container_name="$1"
local database_container_name="$2"
local frontend_container_name="$3"
local gateway_container_name="$4"

backend_container_id=$(docker ps --filter "name=$backend_container_name" --format "{{.ID}}")
db_container_id=$(docker ps --filter "name=$database_container_name" --format "{{.ID}}")
frontend_container_id=$(docker ps --filter "name=$frontend_container_name" --format "{{.ID}}")
gateway_container_id=$(docker ps --filter "name=$gateway_container_name" --format "{{.ID}}")

docker commit $frontend_container_id $frontend_container_name
docker commit $gateway_container_id $gateway_container_name
docker commit $backend_container_id $backend_container_name
docker commit $db_container_id $database_container_name

docker save $frontend_container_name $gateway_container_name $backend_container_name $database_container_name > e2e_release_env_images.tar

# compress the file (to decrease the upload file size)
gzip -c e2e_release_env_images.tar > e2e_release_env_images.tar.gz

# Replace occurrences of 'frontend', 'backend', 'db', and 'gateway' with their respective container names
sed -e "s/frontend/$frontend_container_name/g" \
    -e "s/backend/$backend_container_name/g" \
    -e "s/db/$database_container_name/g" \
    -e "s/gateway/$gateway_container_name/g" \
    docker-compose.template.yml > docker-compose.yml