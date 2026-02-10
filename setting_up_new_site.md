# Setting up new site

This guide will help you setting up a new site configuration in the same repo, reusing some of the configuration used by other sites.

## Pre-requisites

### Hierarchy Overview knowlege (check README.md for more)

This will give you an idea how the multiple sites are inheriting data from the country/ distro level site, and overriding the data, if necessary, on the site level.

### OpenMRS initializer

The OpenMRS initializer is used to add data to the OpenMRS on startup. The data is stored in multiple folders, and in CSV format data. More knowledge about the initializer can be found [here](https://github.com/mekomsolutions/openmrs-module-initializer).

### OpenMRS Reference Data

The OpenMRS Reference Data is a repo, which keeps the baseline metadata essential to run OpenMRS out of box. This data is inherited from OpenMRS to the distro, and then the site level, during the project build.

You can find the links here:

1. OpenMRS Reference Data: https://github.com/openmrs/openmrs-content-referenceapplication
2. OpenMRS Reference Demo Data: https://github.com/openmrs/openmrs-content-referenceapplication-demo

During the build, the metadata from above packages is imported into distro, and then the metadata from distro level is inherited by sites, as is mentioned in the Hierarchy Overview in the README.md.

> _We will be using the MATSAPHA site as an example in this guide_

## Hierarchy knowledge of Matsapha

Matsapha is a city in the country of Eswatini. As per the existing structure of the project, the Hierarchy should have been

```
distro/ => countries/eswatini => sites/matsapha
```

Since we are trying to lower the build time of the project, the current hierarchy is as following:

```
distro/ => sites/matsapha
```

This is defined in the `sites/matsapha/pom.xml` as

```
  <dependencies>
    <dependency>
      <artifactId>ozone-msf-distro</artifactId>
      <groupId>com.ozonemsf</groupId>
      <version>1.0.0-SNAPSHOT</version>
      <type>zip</type>
    </dependency>
  </dependencies>
```

## What does the `distro` contains?

You can explore the `distro/configs/openmrs/initializer_config` to see the metadata saved in distro.

- Ampath Forms
  - F11-Family_Planning_Assessment.json
  - F12-Family_Planning_Follow-up.json
  - F29-MHPSS_Baseline_v2.json
  - F30-MHPSS_Follow-up_v2.json
  - F31-mhGAP_Baseline_v2.json
  - F32-mhGAP_Follow-up_v2.json
  - F33-MHPSS_Closure_v2.json
  - F34-mhGAP_Closure_v2.json
  - F40-Referral\_&_Discharge.json
  - F51-HIV_Baseline.json
  - F52-HIV_Follow-up.json
  - F59-Social_Work_Baseline.json
  - F60-Social_Work_Follow-up.json
  - F73-Gynaecology.json
- Ampath form translations
- Autogeneration options
  - Auto incrementing MSF ID generation for patients
- Common concept definitions to be used by all sites
- Drugs
- Encounter types
- Global properties
- JSON key value
- Patient identifier types
- Person attribute types
- Privileges

The same metadata is then imported on the site level using the above dependency and the following execution defined in the `sites/matsapha/pom.xml`

```xml
<execution>
  <!-- Copy Ozone MSF files -->
  <id>Copy Ozone MSF files</id>
  <phase>process-resources</phase>
  <goals>
    <goal>copy-resources</goal>
  </goals>
  <configuration>
    <outputDirectory>
      ${project.build.directory}/${project.artifactId}-${project.version}</outputDirectory>
    <overwrite>true</overwrite>
    <resources>
      <resource>
        <directory>${project.build.directory}/ozone-msf-distro</directory>
        <excludes>
          <exclude>distro/configs/**/addresshierarchy/*.*</exclude>
          <exclude>distro/configs/**/locations/*.*</exclude>
          <exclude>distro/configs/**/idgen/*.*</exclude>
          <exclude>distro/configs/**/visittypes/*.*</exclude>
          <exclude>distro/configs/**/appointmentservicedefinitions/*.*</exclude>
          <exclude>distro/configs/**/appointmentservicetypes/*.*</exclude>
          <exclude>distro/ozone-info.json</exclude>
        </excludes>
      </resource>
    </resources>
  </configuration>
</execution>
```

This execution will copy all the metadata that is present in the distro after the build is complete. This also contains the metadata from the OpenMRS Reference Data mentioned above under Pre-requisites.

We can define under the `<excludes>` the folder and files we don't want to copy from the distro. As from above snippet, we can see that we are not importing the following from distro:

1. Address Hierarchy
2. Locations
3. ID generation metadata
4. Visit types
5. Appointment related metadata

## How to work on setting up a new site?

Let's set up a new site `Matsapha` for LIME-EMR.

The above knowledge was to give a rough idea of the project structure. Since the new site will most probably personalize the metadata for the site, we can go ahead with copy and pasting the data from Mosul to Matsapha.

After duplicating the Mosul's metadata to Matsapha, we must make the following changes:

### Rename the Frontend Configuration file

Let's rename the file `sites/matsapha/configs/openmrs/frontend_config/msf-mosul-frontend-config.json` to `sites/matsapha/configs/openmrs/frontend_config/msf-matsapha-frontend-config.json`

### Update the `sites/matsapha/pom.xml`

#### Update the project name

Let's update the project name under the tag `<artifactId>` from `ozone-msf-mosul` to `ozone-msf-matsapha`

#### Update the parent of the project

If the Matsapha site is not importing data directly from `distro`, and say is importing data from the country level site, update the dependency as follows:

```
<dependencies>
  <dependency>
    <artifactId>ozone-msf-eswatini</artifactId>
    <groupId>com.ozonemsf</groupId>
    <version>1.0.0-SNAPSHOT</version>
    <type>zip</type>
  </dependency>
</dependencies>
```

#### Exclude specific file import from parent

You can exclude the files not to be imported from the parent project under the plugin `maven-resources-plugin` and execution id `Copy Ozone MSF files`. This is the same configuration mentioned above under _What does distro contain?_

#### Update the frontend configuration file name

The Frontend file name updated in above step is also to be updated in the `pom.xml`. Under the plugin `maven-antrun-plugin` and execution id `Add MSF Matsapha Frontend Configuration`, update as following

```xml
<execution>
  <id>Add MSF Matsapha Frontend Configuration</id>
  <phase>process-resources</phase>
  <goals>
    <goal>run</goal>
  </goals>
  <configuration>
    <target>
      <echo message="Adding MSF Matsapha frontend config"/>
      <replaceregexp file="${project.build.directory}/${project.artifactId}-${project.version}/run/docker/.env"
                  match="(SPA_CONFIG_URLS=.+)" replace="\1,/openmrs/spa/configs/msf-matsapha-frontend-config.json" />
      <replaceregexp file="${project.build.directory}/${project.artifactId}-${project.version}/run/docker/concatenated.env"
                  match="(SPA_CONFIG_URLS=.+)" replace="\1,/openmrs/spa/configs/msf-matsapha-frontend-config.json" />
    </target>
  </configuration>
</execution>
```

This will append to the `SPA_CONFIG_URLS` env variable in the `concatenated.env` file in the build folder, which contains all the env variables for running the project, with the site level frontend configuration file. This variable defines the files loaded by used by OpenMRS frontend when the application loads on the browser.

### Update the OpenMRS metadata for the site

Under the `site/matsapha/configs/openmrs/initializer_config/` folder exists the initializer folders that contains the CSV files defining the metadata under various folders.

Please refer the link mentioned in the [Pre-requisites' OpenMRS Initializer](#openmrs-initializer) to look into all the folders that can be defined in the `initializer_config/` folder.

## Where to see the final metadata for the site

To see the final metadata configs for the site, after running the command `mvn clean package`, you must go to `sites/matsapha/target/ozone-msf-matsapha-<version>/`. This will contain the final metadata that will be used to set up the OpenMRS application for the particular site (here Matsapha).
