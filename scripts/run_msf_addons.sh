#!/bin/bash

echo ""

# Check if MSF OpenFn super user exists in the database
user_exists=$(docker exec $PROJECT_NAME-postgresql-1 bash -c "
    psql -U \${OPENFN_DB_USER} -d \${OPENFN_DB_NAME} -t -c \"
        SELECT * FROM users
        WHERE role = 'superuser'
        AND email = '\${EMAIL_ADMIN}'
        AND first_name = '\${MSF_OPENFN_FIRST_NAME}'
        AND last_name = '\${MSF_OPENFN_LAST_NAME}'
    \"
")
if [[ -n "$user_exists" ]]; then
    echo "$INFO MSF OpenFn super user already exists. Skipping creation..."
else
    echo "$INFO MSF OpenFn super user does not exist. Proceeding with creation..."

    # Adding MSF admin account in a subshell to prevent stopping execution on error
    (
        # create OpenFn user by default
        docker exec -it $PROJECT_NAME-web-1 /app/bin/lightning eval \
            'Lightning.Setup.setup_user(
                %{
                    role: :superuser,
                    email: System.get_env("EMAIL_ADMIN"),
                    first_name: System.get_env("MSF_OPENFN_FIRST_NAME"),
                    last_name: System.get_env("MSF_OPENFN_LAST_NAME"),
                    password: System.get_env("MSF_OPENFN_PASSWORD")
                },
                System.get_env("SECRET_KEY_BASE"),
                [
                    %{
                        name: "openmrs",
                        schema: "raw",
                        body: %{"username" => System.get_env("MSF_OPENMRS_USERNAME"), "instanceUrl" => System.get_env("MSF_OPENMRS_INSTANCE_URL"), "baseUrl" => System.get_env("MSF_OPENMRS_INSTANCE_URL"), "password" => System.get_env("MSF_OPENMRS_PASSWORD")}
                    },
                    %{
                        name: "dhis2",
                        schema: "raw",
                        body: %{"username" => System.get_env("MSF_DHIS2_USERNAME"), "hostUrl" => System.get_env("MSF_DHIS2_HOST_URL"), "password" => System.get_env("MSF_DHIS2_PASSWORD")}
                    }
                ]
            )'  && echo "$INFO Creating OpenFn admin user completed successfully."

    ) || echo "$ERROR Creating OpenFn admin user failed. Skipping"
    echo ""
fi

# this step requires internet. It downloads node modules. Should be run on the host
echo "$INFO Pre-warming worker cache with adaptors..."
docker exec -it $PROJECT_NAME-worker-1 sh -c "npm install -g @openfn/cli@1.11.4 && openfn repo install  -a common@latest -a collections@latest -a http@6.5.1 -a openmrs@4.1.3 -a dhis2@5.0.1"

echo ""
echo "$INFO copying OpenFn files to $PROJECT_NAME-worker-1"
copy_openfn_files_status=true
(
    docker exec $PROJECT_NAME-worker-1 mkdir -p /app/packages/ws-worker/lime
    export OPENFN_CONFIG_PATH_IN_SCRIPTS=../$OPENFN_CONFIG_PATH
    docker cp $OPENFN_CONFIG_PATH_IN_SCRIPTS/config.json $PROJECT_NAME-worker-1:/app/packages/ws-worker/lime/
    docker cp $OPENFN_CONFIG_PATH_IN_SCRIPTS/openfn-project.yaml $PROJECT_NAME-worker-1:/app/packages/ws-worker/lime/
    docker cp $OPENFN_CONFIG_PATH_IN_SCRIPTS/projectState.json $PROJECT_NAME-worker-1:/app/packages/ws-worker/lime/
) || copy_openfn_files_status=false


# Check if any file copying failed
if [ "$copy_openfn_files_status" = true ]; then
    echo "$INFO Successfully copied OpenFn files to $PROJECT_NAME-worker-1."

    echo ""
    echo "$INFO Deploying latest version of the OpenFn workflow"
    deploy_openfn_workflow_status=true
    docker exec $PROJECT_NAME-worker-1 sh -c "cd /app/packages/ws-worker/lime && openfn deploy -c config.json --no-confirm" || deploy_openfn_workflow_status=false
    if [ "$deploy_openfn_workflow_status" = true ]; then
        echo "$INFO OpenFn workflow deployed successfully."
    else
        echo "$ERROR Unable to deploy OpenFn workflow."
    fi
else
    echo "$ERROR Failed to copy some OpenFn files. Skipping OpenFn workflow deployment."
fi
