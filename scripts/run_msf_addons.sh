#!/bin/bash

echo ""
echo "$INFO Creating OpenFn admin user..."

# Adding MSF admin account in a subshell to prevent stopping execution on error
(
    # create OpenFn user by default
    docker exec -it ozone-msf-distro-web-1 /app/bin/lightning eval \
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
                    body: %{"username" => System.get_env("MSF_OPENMRS_USERNAME"), "password" => System.get_env("MSF_OPENMRS_PASSWORD")}
                },
                %{
                    name: "dhis2",
                    schema: "raw",
                    body: %{"username" => System.get_env("MSF_DHIS2_USERNAME"), "password" => System.get_env("MSF_DHIS2_PASSWORD")}
                }
            ]
        )'  && echo "$INFO Creating OpenFn admin user completed successfully."

) || echo "$ERROR Creating OpenFn admin user failed. Skipping"
echo ""
