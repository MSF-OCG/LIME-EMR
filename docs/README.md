# Introduction

> Note: This documentation describes how the OpenMRS 3.x demo for the MSF OCG LIME project is running. It follows standard practices from OpenMRS and its community, and goes through the lifecycle of the product. The integration with other dependencies such as [OpenConceptLab (OCL)](https://openconceptlab.org/) and [DHIS2](https://dhis2.org/) is also documented here. Any feedback and pull requests are welcomed to continuously improved this demo!

# Getting started

## Prerequisites
1. Setup Docker on the localhost and hosting instances
2. Get the latest docker-compose.yml
3. Pull the latest images and run the app with Docker Compose (docker-compose pull && docker-compose up -d)

## Tools
- Diagram and pathway design tool: https://bpmn.io/

## File structure

```shell
├ ~/home/docker-compose.yml # file to run Docker images for the App (docker-compose up -d)
│  ├─ distro/ # main folder for OpenMRS backend
│  │  ├── distro.properties # file to configure OpenMRS version and modules (OMODs)
│  │  └── configuration/ # folder with metadata loaded with Initializer
│  └─ frontend / # main folder for OpenMRS frontend
│     ├── spa-build-config.json # file to configure OpenMRS 3.x frontend properties and modules
│     └── custom-config.json # file to configure frontend customizations (visiblity, order, logo, etc.)
├ ~/var/lime/ # directory for app files
├ ~/var/log/ # directory for logs
└ ~/var/lib/docker/volumes/ # directory where Docker will store volumes for data persistence
```
## Docker Compose

> ~/srv/docker-compose.yml

Docker diagram
<div>
<img src="./_media/docker-compose.png" width=80%>
</div>

```yml
version: "3.7"

services:
  gateway:
    image: openmrs/openmrs-reference-application-3-gateway:${TAG:-nightly}
    depends_on:
      - frontend
      - backend
    ports:
      - "80:80"

  frontend:
    image: msfocg/openmrs3-frontend:dev
    environment:
      SPA_PATH: /openmrs/spa
      API_URL: /openmrs
      SPA_CONFIG_URLS: /openmrs/spa/custom-config.json
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      timeout: 5s
    depends_on:
      - backend
    volumes:
      - ./frontend/custom-config.json:/usr/share/nginx/html/custom-config.json

  backend:
    image: msfocg/openmrs3-backend:dev
    depends_on:
      - db
    environment:
      OMRS_CONFIG_MODULE_WEB_ADMIN: "true"
      OMRS_CONFIG_AUTO_UPDATE_DATABASE: "true"
      OMRS_CONFIG_CREATE_TABLES: "true"
      OMRS_CONFIG_CONNECTION_SERVER: db
      OMRS_CONFIG_CONNECTION_DATABASE: openmrs
      OMRS_CONFIG_CONNECTION_USERNAME: ${OPENMRS_DB_USER:-openmrs}
      OMRS_CONFIG_CONNECTION_PASSWORD: ${OPENMRS_DB_PASSWORD:-openmrs}
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/openmrs"]
      timeout: 5s
    volumes:
      - openmrs-data:/openmrs/data
      - ./distro/configuration:/openmrs/distribution/openmrs_config

  # MariaDB
  db:
    image: mariadb:10.8.2
    command: "mysqld --character-set-server=utf8 --collation-server=utf8_general_ci"
    healthcheck:
      test: "mysql --user=${OMRS_DB_USER:-openmrs} --password=${OMRS_DB_PASSWORD:-openmrs} --execute \"SHOW DATABASES;\""
      interval: 3s
      timeout: 1s
      retries: 5
    environment:
      MYSQL_DATABASE: openmrs
      MYSQL_USER: ${OMRS_DB_USER:-openmrs}
      MYSQL_PASSWORD: ${OMRS_DB_PASSWORD:-openmrs}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD:-openmrs}
    volumes:
      - db-data:/var/lib/mysql

volumes:
  openmrs-data: ~
  db-data: ~

```



# Configure

Types of configurations:
1. OpenMRS version (/distro/distro.properties)
2. Backend modules (/distro/distro.properties)
3. Frontend modules (/frontend/spa-build-config.json)
4. Frontend customizations (/frontend/custom-config.json)
5. Metadata (/distro/configuration)
6. Concepts and content (OCL)

> #### [Diagram representing the types of configuration](https://docs.google.com/drawings/d/1FqoAuYAhWf-P8YAd18wHN-7yRBnAKEkrabBSGOCkWr8/edit?usp=sharing)


## OpenMRS version

> /distro/distro.properties

```shell
name=Ref 3.x distro
version=3.0.0
war.openmrs=${openmrs.version}
```
## Backend modules

> /distro/distro.properties

```shell
omod.initializer=${initializer.version}
omod.fhir2=${fhir2.version}
omod.webservices.rest=${webservices.rest.version}
omod.idgen=${idgen.version}
omod.addresshierarchy=${addresshierarchy.version}
omod.openconceptlab=${openconceptlab.version}
omod.attachments=${attachments.version}
omod.queue=${queue.version}
omod.appointments=${appointments.version}
omod.appointments.groupId=org.bahmni.module
omod.cohort=${cohort.version}
omod.reporting=${reporting.version}
omod.reportingrest=${reportingrest.version}
omod.calculation=${calculation.version}
omod.serialization.xstream=${serialization-xstream.version}
omod.serialization.xstream.type=omod
```
## Frontend modules

> /frontend/spa-build-config.json

```json
{
  "frontendModules": {
    "@openmrs/esm-devtools-app": "next",
    "@openmrs/esm-implementer-tools-app": "next",
    "@openmrs/esm-login-app": "next",
    "@openmrs/esm-offline-tools-app": "next",
    "@openmrs/esm-primary-navigation-app": "next",
    "@openmrs/esm-home-app": "next",
    "@openmrs/esm-form-entry-app": "next",
    "@openmrs/esm-generic-patient-widgets-app": "next",
    "@openmrs/esm-patient-allergies-app": "next",
    "@openmrs/esm-patient-appointments-app": "next",
    "@openmrs/esm-patient-attachments-app": "next",
    "@openmrs/esm-patient-banner-app": "next",
    "@openmrs/esm-patient-biometrics-app": "next",
    "@openmrs/esm-patient-chart-app": "next",
    "@openmrs/esm-patient-conditions-app": "next",
    "@openmrs/esm-patient-forms-app": "next",
    "@openmrs/esm-patient-medications-app": "next",
    "@openmrs/esm-patient-notes-app": "next",
    "@openmrs/esm-patient-programs-app": "next",
    "@openmrs/esm-patient-test-results-app": "next",
    "@openmrs/esm-patient-vitals-app": "next",
    "@openmrs/esm-active-visits-app": "next",
    "@openmrs/esm-appointments-app": "next",
    "@openmrs/esm-outpatient-app": "next",
    "@openmrs/esm-patient-list-app": "next",
    "@openmrs/esm-patient-registration-app": "next",
    "@openmrs/esm-patient-search-app": "next",
    "@openmrs/esm-openconceptlab-app": "next",
    "@openmrs/esm-dispensing-app": "next",
    "@openmrs/esm-fast-data-entry-app": "next",
    "@openmrs/esm-cohort-builder-app": "next",
    "@openmrs/esm-form-builder-app": "next"
  },
  "spaPath": "$SPA_PATH",
  "apiUrl": "$API_URL",
  "configUrls": ["$SPA_CONFIG_URLS"],
  "importmap": "$SPA_PATH/importmap.json"
}

```

## Frontend customizations

> /frontend/custom-config.json

### Examples

#### Modify branding and styleguide
```json
"@openmrs/esm-patient-chart-app": {
  "logo": {
    "src": "header-logo.png"
  }
},
"@openmrs/esm-login-app": {
  "logo": {
    "src": "logo.png"
  }
},
"@openmrs/esm-primary-navigation-app": {
  "logo": {
    "src": "header-logo.png"
  }
},
"@openmrs/esm-styleguide": {
  "Brand color #1": "#D7211E",
  "Brand color #2": "#414141",
  "Brand color #3": "#D7211E"
}
```

#### Modify navigation
```json
"@openmrs/esm-primary-navigation-app": {
  "extensionSlots": {
    "patient-chart-dashboard-slot": {
      "remove": [
        "offline-tools-patient-chart-actions-dashboard-link"
      ]
    }
  }
}
```


#### Modify the registration content
```json
"@openmrs/esm-patient-registration-app": {
  "fieldDefinitions": [
    {
      "id": "referredby",
      "name": "Referred by",
      "type": "person attribute",
      "uuid": "4dd56a75-14ab-4148-8700-1f4f704dc5b0",
      "answerConceptSetUuid": "6682d17f-0777-45e4-a39b-93f77eb3531c",
      "validation": {
        "matches": ""
      }
    }
  ],
  "sectionDefinitions": [
    {
      "id": "additionalDetails",
      "name": "Additional Details",
      "fields": [
        "referredby"
      ]
    }
  ],
  "sections": [
    "demographics",
    "relationships",
    "contact",
    "additionalDetails"
  ],
  "fieldConfigurations": {
    "gender": [
      {
        "id": "male",
        "value": "Male",
        "label": "Male"
      },
      {
        "id": "female",
        "value": "Female",
        "label": "Female"
      },
      {
        "id": "other",
        "value": "Other",
        "label": "Other"
      }
    ]
  }
}
```

#### Modify the vital signs form
```json
"@openmrs/esm-patient-vitals-app": {
  "vitals": {
    "useFormEngine": true,
    "formName": "Surgical Operation",
    "formUuid": "96637f12-3c04-311f-b477-3fa6a866e895",
    "encounterTypeUuid": "67a71486-1a54-468f-ac3e-7091a9a79584"
  }
}
```


## Metadata


Configurations are loaded through the Initializer module and located in the configuration folder
> /distro/configuration
```shell
# Configuration files are loaded when restarting OpenMRS and the Docker backend image
docker restart lime-emr-project-demo-backend
```

## Concepts and content

Content is organized in OpenConceptLab (OCL), in the [LIME Demo collection](https://app.openconceptlab.org/#/orgs/MSFOCG/collections/lime-demo/ ) and manually exported as ZIP files, then added to the configuration:
> /distro/configuration/OCL

In CSV templats
1. Define project-specific metadata
In OpenConceptLab (OCL)
2. Identify concepts that can be reused in a) CIEL source b) MSF sources
3. Create new concepts if needed in MSF OCG source
4. Create collections of concepts needed for the implementation (per program, per form, and generic ones)
5. Release the collection and export it as a ZIP file
In distribution configuration
1. Add the ZIP file in /distro/configuration/ampathforms/___.zip
2. Restart OpenMRS to verify that the new concepts are well loaded in the OpenMRS dictionnary

### OpenConceptLab (OCL)

UUID formula for Excel:
```shell
=LOWER(CONCATENATE(DEC2HEX(RANDBETWEEN(0,POWER(16,8)),8),"-",DEC2HEX(RANDBETWEEN(0,POWER(16,4)),4),"-","4",DEC2HEX(RANDBETWEEN(0,POWER(16,3)),3),"-",DEC2HEX(RANDBETWEEN(8,11)),DEC2HEX(RANDBETWEEN(0,POWER(16,3)),3),"-",DEC2HEX(RANDBETWEEN(0,POWER(16,8)),8),DEC2HEX(RANDBETWEEN(0,POWER(16,4)),4)))
```

# Translations

## Configuration

1. Add the locale in the supported language in the distro in: https://github.com/openmrs/openmrs-distro-referenceapplication/blob/758a11fc510df7dd09e23b565ebc8e366cf9e673/distro/configuration/globalproperties/i18n.xml#L5

## Frontend UI

1. checkout the mono repo
2. install dependencies using `yarn`
3. add new language locale code
4. create additional translation files using `yarn run extract-translations`
5. update the translation files
6. reflect translations in Transifex
7. commit and pull request

List of i18next parsers
- https://github.com/openmrs/openmrs-esm-core/blob/17830ad39ae631d33a4db9b6a7e1b021ce8e8847/tools/i18next-parser.config.js#L45
- https://github.com/openmrs/openmrs-esm-patient-chart/blob/46602a6a9f8d60be01a11d538226c095d433b589/tools/i18next-parser.config.js#L45
- https://github.com/openmrs/openmrs-esm-patient-management/blob/40ca359d14608f0cea13677a1d2633e9b0ccd8c2/tools/i18next-parser.config.js#L45
- https://github.com/openmrs/openmrs-esm-template-app/blob/5844f04c5d9e249f0342f2cbbf0bf66010d6e2d0/i18next-parser.config.js#L45
- https://github.com/openmrs/openmrs-esm-admin-tools/blob/4ebc0cb3206bf124812d3169f1048c182ee00cb4/tools/i18next-parser.config.js#L45
- https://github.com/openmrs/openmrs-esm-fast-data-entry-app/blob/d75f71933dcd8ccc36c27496d7ba498ade016f4e/tools/i18next-parser.config.js#L45

## Forms and content

1. add translation in OCL concepts
2. pull release in OpenMRS from OCL using the Initializer
3. leave the form labels empty to pull the label based on the translations in the concepts

# Build
Docker images will automatically be rebuilt and pushed to [Docker Hub of MSF OCG](https://hub.docker.com/r/msfocg) when binaries or configurations are modified.

## Actions


### Build Docker images
### Update metadata and content

#### Update OpenMRS frontend
rebuild frontend image in Github Actions
docker compose --profile openmrs3 pull
docker compose --profile openmrs3 up d
#### Update OpenMRS backend
rebuild backend image in Github Actions
docker compose --profile openmrs3 pull
docker compose --profile openmrs3 up d
#### Update content
git pull
docker restart backent

### Update documentation

## Branches

<div>
<img src="./_media/development-workflow.png" width=80%>
</div>

## Environments

Dev, QA/UAT, Preprod, prod

| Environment | Dockerfile | Docker compose | Comment |
|---|---|---|---|
| Local | Modified to load custom frontend assets (logo, config json, etc.) | docker-compose.local.yml | Loading distro/configuration from the Docker host (local machine) when restarting the Docker backend, frontend must be rebuilt if modified (assets, spa modules, etc) |
| Dev/Staging/Prod | Modified to load custom frontend assets (logo, config json, etc.) | docker-compose.yml | Loading frontend and backend Docker images built in Github actions and pushed to Docker Hub |

# Deploy

## On localhost
```shell
# SSH Azure instance via jumphost
ssh username@____.cloudapp.azure.com -p ____
# switch to sudo privileges
sudo su
# Start OpenMRS
docker-compose up -d
# Verify that OpenMRS services are running
docker ps
# IF docker-compose file is missing, download configuration, then start OpenMRS
curl https://raw.githubusercontent.com/openmrs/openmrs-distro-referenceapplication/main/docker-compose.yml > docker-compose.yml
# Verify that the web app is available
https://___.cloudapp.azure.com
# All done!
```

## In the Cloud

Ansible script to build

```shell
# Add Ansible repository
sudo apt-add-repository ppa:ansible/ansible
# Refresh system package index
sudo apt update
# Install Ansible
sudo apt install ansible
# Run the recipe
ansible-playbook -i inventories/dev.ini playbook.yaml --ask-become-pass
```
## On premises

# Maintain

Type of maintenance activities

| Activity | Comments |
|---|---|
| 1. Backup data and patient files | Automated, nightly, locally on production |
| 2. Synchronize production data with QA and DEV environments | Manual, from GitHub Sync actions |
| 3. Upgrade binaries | Manual, from GitHub Build actions |
| 4. Update metadata and configurations | Manual, from GitHub Build actions |

## Backup

### Overview

<div>
<img src="./_media/backup-diagram.png" width=50%>
</div>


#### Instructions to backup the database on a daily or weekly basis, encrypt it, and transfer to another location:

### Prerequisites

#### Step 1: Install GPG on the backup server

You can install GPG on your backup server using your distribution's package manager. For example, on Ubuntu or Debian, you can use the following command:
```shell
sudo apt-get update
sudo apt-get install gnupg
```

#### Step 2: Generate a GPG key pair

You can generate a GPG key pair using the following command:

```shell
gpg --gen-key
```

This will launch a series of prompts to configure your key pair. Follow the prompts to create your key pair.

#### Step 3: Export the public key

Once you have generated your key pair, you need to export the public key and share it with the users who will be encrypting backups for you.

You can export the public key using the following command:

```shell
gpg --export -a "Your Name" > public_key.asc
```
Replace "Your Name" with the name you used when generating your key pair.

#### Step 4: Encrypt backups using GPG

To encrypt a backup using GPG, you can use the following command:

```shell
gpg --encrypt --recipient "Your Name" backup_file.tar.gz
```
Replace "Your Name" with the name associated with your GPG key pair, and replace "backup_file.tar.gz" with the name of your backup file.

### Consolidated script

```shell
#!/bin/bash

# Set the date format
now=$(date +"%Y_%m_%d")

# Perform daily incremental backup of the database
docker exec openmrs-db /usr/bin/mysqldump --max_allowed_packet=51012M -u '****' --password='******' openmrs --skip-lock-tables --single-transaction --skip-triggers | gzip -v > /openmrs/backup/lime_dc_db_daily_$now.sql.gz

# Perform weekly incremental backup of the database
if [ $(date +%u) -eq 7 ]; then
  docker exec openmrs-db /usr/bin/mysqldump --max_allowed_packet=51012M -u '****' --password='******' openmrs --skip-lock-tables --single-transaction --skip-triggers | gzip -v > /openmrs/backup/lime_dc_db_weekly_$now.sql.gz
fi

# Encrypt backup file using GPG
gpg --encrypt --recipient "Your Name" /ptracker/backup/ptracker_dc_db.sql.gz

# Perform incremental backup of the storage and files
rsync -a --delete /lime/storage/ backup@172.24.xx.xx:/openmrs/backup/lime_dc_storage/

# Perform incremental backup of the OpenMRS files
rsync -a --delete /lime/openmrs/ backup@172.24.xx.xx:/openmrs/backup/lime_dc_files/

# Create a log message with timestamp
echo "$(date): Daily and weekly incremental backup of OpenMRS database and incremental backup of storage and files has been performed."
```
This script performs a MySQL dump of an OpenMRS database, compresses the output and transfers it to a backup server. It also adds a time stamp message to a log file.

### Line-by-line explanation of the script

```now=$(date +"%Y_%m_%d")```: This line creates a variable now that captures the current date in the format of year, month, and day.

```shell docker exec ptracker-openmrs-db /usr/bin/mysqldump --max_allowed_packet=51012M -u '****' --password='******' openmrs --skip-lock-tables | gzip -v > /lime/backup/lime_dc_db.sql.gz```: This line uses Docker to execute a MySQL dump command with specific parameters. It dumps the database named openmrs to the standard output and pipes it to gzip, which compresses the output. The compressed output is then redirected to a backup file named ptracker_dc_db.sql.gz in the /ptracker/backup/ directory.

```scp -i '/openmrs/backup/backup_key' /openmrs/backup/lime_dc_db.sql.gz backup@172.24.xx.xx:/openmrs/backup/lime_dc_db_$now.sql.gz```: This line uses scp to securely copy the backup file to a backup server. It uses the key stored in /lime/backup/backup_key to authenticate the transfer. The file is transferred to the user backup at IP address 172.24.xx.xx, and it is renamed to include the timestamp variable $now in the file name.

```echo $now Backup of openmrs db has run```: This line appends a message to a log file that confirms that the backup has been run. The message includes the timestamp variable $now.


## Deitentify

## Restore

## Update

Type of updates:
1. Binaries (OpenMRS files) - updated by Build actions
2. Metadata and configuration - updated by Configuration actions
3. Local data update - done manually by project team

Latest images can be pulled on instances using the Docker command:
```shell
docker-compose pull && docker-compose up -d
```

# Development tooling

## Local database
### Connect DBeaver to the Docker MariaDB container
1. Update the openmrs user to be usable from the host machine
```shell
## Login in the MariaDB container
docker exec -it lime-emr-project-demo-db-1 sh
## Connect to MySQL as root
mysql -u root -p
## Update the host allowance of the openmrs user
update mysql.user set host='%' where user='openmrs'
```
2. In MariaDB
  a. Set the server host as "localhost", the port as "3306", the database as "openmrs" and the database authentication username as "openmrs"
  b. In the driver properties, set the "allowPublicKeyRetrieval" to "true"
3. Test the connection to confirm that it is successful
4. Configure the Proxy SSH/Proxy to do the same on a remote server
