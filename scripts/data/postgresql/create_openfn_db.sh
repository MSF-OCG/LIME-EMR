#!/bin/bash

set -eu

function create_user_and_database() {
	local database=$1
	local user=$2
	local password=$3
	echo "Creating '$user' user and '$database' database..."
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" $POSTGRES_DB <<-EOSQL
	    CREATE USER $user WITH  PASSWORD '$password';
	    CREATE DATABASE $database;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $user;
		GRANT $user TO $POSTGRES_USER;
EOSQL
	# PostgreSQL 15+ revoked CREATE on public schema from PUBLIC by default.
	# Explicitly grant it so Ecto migrations can create schema_migrations.
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$database" <<-EOSQL
	    GRANT ALL ON SCHEMA public TO $user;
EOSQL
}

echo "Running OpenFn Database initialization script"

create_user_and_database ${OPENFN_DB_NAME} ${OPENFN_DB_USER} ${OPENFN_DB_PASSWORD}
