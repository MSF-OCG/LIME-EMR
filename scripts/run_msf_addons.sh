#!/bin/bash

echo ""
echo "$INFO Creating OpenFn admin user..."

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
                    body: %{"username" => System.get_env("MSF_OPENMRS_USERNAME"), "instanceUrl" => System.get_env("MSF_OPENMRS_INSTANCE_URL"), "password" => System.get_env("MSF_OPENMRS_PASSWORD")}
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
docker compose run --rm worker npm install -g @openfn/cli && openfn repo install -a http@6.5.1 -a openmrs@4.1.3 -a dhis2@5.0.1
