# Ozone MSF
### Workflow diagram

```mermaid
%%{init: {'theme':'forest'}}%%
flowchart TD

subgraph Z["Github Repository 'LIME EMR'"]
direction LR
  A[Configuration in Github repository] -->|Release of Distro config| B[Build in Github Actions]
      A -->|Release of a Country config| B
      A -->|Release of a Site config| B
      A -->|Release of an Environment config| B
  B --> |Generate a Distro artefact| C[Artefact Repository in Github]
      B --> |Generate a Country artefact| C
      B --> |Generate a Site artefact| C
end

subgraph ZA["Execution Server"]
direction LR
      D[Running the LIME EMR]
end

Z --> |Pulling the artefacts| ZA
```
#### Hierarchy overview
```
── pom.xml - Aggredator / Orchestrator  
      └── /distro/pom.xml - Organizational-wide Config  
      └── /countries - Country-specific Config  
            └── /iraq/pom.xl
      └── /sites - Site-specific Config  
            └── /mosul/pom.xl
```
#### How to configure the pom files 
- GroupId
- ArtifactID
- Version

- Dependencies

- Build
- Plugins

- Execution
- Configuration
- Exclude

- DistributionManagement

### 1. Configure
- [x] Configure the Organization level - MSF  
- [x] Configure the Country level - Iraq  
- [x] Configure the Site level - Mosul  
### 2. Build
- [x] Successfully build the Mosul site distro + above dependencies (Country and Organization levels inherited)
- [ ] Optional: Separate the builds (Org, Country, Site) and make it generic if possible
### 3. Execution
- [ ] Run the OpenMRS Docker Compose with the Mosul distro locally using the updated Shell script (Tooling procedures)
- [x] Next: Plan for testing on MSF instance 
- [ ] Optional: Run E2E testing

## Config hierarchy
```
── OpenMRS RefApp level - Ozone (ex. base modules, docker images, etc.). 
      └── Org level - MSF Distro - config across MSF implementations _(ex. branding, modules versions, etc. )  
            └── Country level - MSF Iraq specific config (ex. languages)  
                └── Site level - MSF Mosul specific config (ex. address hierarchy, roles, etc.)  
                └── Site level - MSF Baghdad specific config (ex. address hierarchy, roles, etc.)  
            └── Country level - MSF DRC specific config (ex. languages)   
                └── Site level - MSF Goma specific config (ex. modules, locations, etc)  
```

## Example for configs for hierarchy demo of v1 - Week of April 8
### Ozone Level **OpenMRS RefApp**   
- [x] Refapp stable version of [modules for frontend](https://github.com/openmrs/openmrs-distro-referenceapplication/blob/main/frontend/spa-assemble-config.json)  
- [x] Refapp stable version of [modules for backend](https://github.com/openmrs/openmrs-distro-referenceapplication/blob/main/distro/pom.xml)  
### MSF Distro **LIME EMR** repository  
- [x] MSF [branding in frontend config](https://github.com/MSF-OCG/LIME-EMR-project-demo/blob/main/frontend/custom-config.json)   
- [x] MSF [logo and assets](https://github.com/MSF-OCG/LIME-EMR-project-demo/tree/main/frontend/assets)
- [x] [Env specific logos](https://github.com/MSF-OCG/LIME-EMR-project-demo/blob/dev/frontend/qa/assets/logo.png) for users to easily identify their environment 
### Country level: **Iraq**   
- [x] [Roles config](https://github.com/MSF-OCG/LIME-EMR-project-demo/blob/main/distro/configuration/roles/roles_core-demo.csv) for Initializer  
### Site level: **Mosul**  
- [x] [Address hierarchy](https://github.com/MSF-OCG/LIME-EMR-project-demo/tree/main/distro/configuration/addresshierarchy) for Initializer  
- [x] [Locations](https://github.com/MSF-OCG/LIME-EMR-project-demo/blob/main/distro/configuration/locations/locations.csv) for Initializer  
- [x] [Person attributes](https://github.com/MSF-OCG/LIME-EMR-project-demo/blob/main/distro/configuration/personattributetypes/personattributetypes_core-demo.csv) for Initializer
- [x] [Initial consultation form](https://github.com/MSF-OCG/LIME-EMR-project-demo/blob/main/distro/configuration/ampathforms/initial_consultation-lime_demo.json)


## Ozone documentation
**Ozone MSF** is a distribution of [Ozone HIS](https://www.ozone-his.com).

Please refer to the online Ozone documentation for instructions how to run the project: https://docs.ozone-his.com/create-distro/#available-commands


```
$ git clone https://github.com/mekomsolutions/ozone-msf
$ cd ozone-msf
```

## Quick Start

Build
```bash
./scripts/mvnw clean package
```

Running MSF Distro
```bash
source distro/target/go-to-scripts-dir.sh
./start-demo.sh
```

Running MSF Iraq
```bash
cd countries/iraq/target/ozone-msf-iraq-<version>/run/docker/scripts
./start-demo.sh
```

Running MSF Mosul
```bash
cd sites/mosul/target/ozone-msf-mosul-<version>/run/docker/scripts
./start-demo.sh
```

## Testing

1. Install prerequisites
   brew install jq 
3. Clone EMR Tooling
   
4. Update install directory
   ```bash
   INSTALL_DIR="**.**/home/lime/$APP_NAME"
   ```
5. Disable logging in lime_emr.sh (success and error)
# Function to log success messages
```bash
log_success() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] Success: $1" # >> "$SUCCESS_LOG"
}
```
Comment out Function to log error messages
```bash
log_error() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] Error: $1" # >> "$ERROR_LOG"
}
```
6. Comment out download_msf_artefact() function
```bash
   # curl -L -o "$download_name.zip" -H "$GITHUB_REQUEST_TYPE" -H "$GITHUB_AUTH_HEADER" -H "$GITHUB_API_VERSION" "$download_url" && log_success "Downloaded MSF Distro for the '$artifact_branch' branch." || log_error "Failed to download MSF Distro for the '$artifact_branch' branch."
```
7. Remove docker and package installation if needed

8. Run installation script
   chmod +x ./Procedures/lime_emr.sh
   sh ./Procedures/lime_emr.sh install mosul

## Release Notes

### 1.0.0-SNAPSHOT (in progress)
