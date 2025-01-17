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

    # this step requires internet. It downloads node modules. Should be run on the host
    echo "$INFO Pre-warming worker cache with adaptors..."
    docker exec -it $PROJECT_NAME-worker-1 sh -c "npm install -g @openfn/cli && openfn repo install  -a common@latest -a collections@latest -a http@6.5.1 -a openmrs@4.1.3 -a dhis2@5.0.1"
fi
