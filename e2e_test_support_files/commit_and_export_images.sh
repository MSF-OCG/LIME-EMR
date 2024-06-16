#!/bin/bash

backend_container_name="$1"
db_container_name="$2"
frontend_container_name="$3"
gateway_container_name="$4"

backend_container_id=$(docker ps --filter "name=$backend_container_name" --format "{{.ID}}")
db_container_id=$(docker ps --filter "name=$db_container_name" --format "{{.ID}}")
frontend_container_id=$(docker ps --filter "name=$frontend_container_name" --format "{{.ID}}")
gateway_container_id=$(docker ps --filter "name=$gateway_container_name" --format "{{.ID}}")

docker commit $frontend_container_id $frontend_container_name
docker commit $gateway_container_id $gateway_container_name
docker commit $backend_container_id $backend_container_name
docker commit $db_container_id $db_container_name

docker save $frontend_container_name $gateway_container_name $backend_container_name $db_container_name > e2e_release_env_images.tar

# compress the file (to decrease the upload file size)
gzip -c e2e_release_env_images.tar > e2e_release_env_images.tar.gz

# Replace occurrences of 'frontend', 'backend', 'db', and 'gateway' with their respective container names in one command

sed -e "s/frontend/$frontend_container_name/g" \
    -e "s/backend/$backend_container_name/g" \
    -e "s/db/$db_container_name/g" \
    -e "s/gateway/$gateway_container_name/g" \
    e2e_test_support_files/docker-compose.template.yml > e2e_test_support_files/docker-compose.yml