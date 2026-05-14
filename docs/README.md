# LIME EMR Documentation

> **LIME EMR** (Light Modular EMR) is an [OpenMRS 3](https://openmrs.org/) distribution built by [MSF OCG](https://www.msf.org/), operated and maintained by [Madiro Labs](https://madiro.org/). It provides a generic, modular Electronic Medical Record system for humanitarian healthcare settings, with active deployments across Iraq, Eswatini, and DRC.

**Source repository:** [MSF-OCG/LIME-EMR](https://github.com/MSF-OCG/LIME-EMR) — open source, contributions welcome.

---

## Deployment Sites

| Site | Country | Clinical Forms | Description |
|------|---------|---------------|-------------|
| **Distro** (MSF base) | -- | 26 forms | Core programs: mental health (MHPSS/mhGAP v2), family planning, HIV, social work, gynaecology, surgery/anaesthesia, procedures/transfusion, wound dressing, radiology, referral & discharge |
| **LIME Demo** | -- | 26 forms (distro only) | Generic showcase environment. Runs the distro level directly with no site-specific overrides — used to demonstrate new OpenMRS versions and features. |
| **Mosul** | Iraq 🇮🇶 | 77 total (51 site-specific + 26 from distro) | Full hospital: obstetrics, ER, maternity, paediatrics, neonatology, ICU, infectious diseases (TB/HBV/HCV/NCDs), palliative care, nutrition, NTDs, and specialized programs. Arabic/English. DHIS2 sync via OpenFn. Live in production since 2024. |
| **Matsapha** | Eswatini 🇸🇿 | Inherits distro | Site with custom branding, address hierarchy, ID generation, and OpenFn configuration |
| **Bunia** | DRC 🇨🇩 | Inherits distro | Site with custom branding, address hierarchy, ID generation, roles, and OpenFn configuration |

---

## Architecture

LIME EMR follows a **three-level configuration inheritance model** designed for multi-site humanitarian deployments:

1. **Distro** (`/distro`) — Organization-wide MSF base configuration. Defines backend modules, frontend modules, core clinical forms, concept dictionaries, drug lists, roles, and branding shared across all MSF sites.
2. **Country** (`/countries/<name>`) — Country-specific overrides (e.g., Iraq-specific metadata or roles).
3. **Site** (`/sites/<name>`) — Site-specific overrides. Adds address hierarchies, locations, ID generation, site-specific clinical forms, translations, and OpenFn workflows for a particular facility.

Each lower level inherits everything from the level above and can selectively override or extend any configuration file. The build system (Maven) assembles everything at build time.

### Technology Stack

| Layer | Technologies |
|-------|-------------|
| **Backend** | OpenMRS Core 2.7.7, Java 8, 20+ OpenMRS modules (FHIR2, Initializer, Appointments, Queue, Forms, Reporting, etc.) |
| **Frontend** | OpenMRS 3 ESM microfrontend architecture (41 modules), plus custom Madiro modules (Nutrition, Mental Health) |
| **Data exchange** | OpenFn Lightning for DHIS2 sync, FHIR R4 API, OpenConceptLab |
| **Infrastructure** | Docker Compose, Traefik v2.6 (SSL), Keycloak (OAuth2), MySQL, PostgreSQL |
| **Build** | Apache Maven (multi-module aggregator), GitHub Actions CI/CD, GitHub Packages |
| **Testing** | Playwright v1.49.0 (E2E), BrowserStack |

### Runtime Services

The system runs as a set of Docker containers orchestrated by Docker Compose:

```
Traefik (SSL) ──► OpenMRS Frontend (ESM)
                         │ REST API
                  OpenMRS Backend (Java 8) ──► MySQL
                         │ FHIR / REST
                  OpenFn Lightning ──────────► PostgreSQL
                         │ Tracker API
                        DHIS2
```

---

## Quick Start (Local Development)

### Prerequisites

- Java 8+
- Maven 3.x (a Maven wrapper `./scripts/mvnw` is included)
- Docker and Docker Compose
- A GitHub personal access token configured in `~/.m2/settings.xml`

### Build

```bash
./scripts/mvnw clean package
```

### Run the base distro

```bash
source distro/target/go-to-scripts-dir.sh
./start-demo.sh
```

> OpenMRS will be available at `http://localhost:4001/openmrs`.

### Run a specific site

```bash
# Mosul (Iraq)
cd sites/mosul/target/ozone-msf-mosul-<version>/run/docker/scripts
./start-demo.sh

# Matsapha (Eswatini)
cd sites/matsapha/target/ozone-msf-matsapha-<version>/run/docker/scripts
./start-demo.sh

# Bunia (DRC)
cd sites/bunia/target/ozone-msf-bunia-<version>/run/docker/scripts
./start-demo.sh
```

---

## Configuration

All clinical metadata is managed via the [OpenMRS Initializer module](https://github.com/mekomsolutions/openmrs-module-initializer), which loads structured configuration files (CSV, JSON) on startup. No manual database imports are needed.

### Configuration types

| Type | Location | Format |
|------|----------|--------|
| Backend modules | `distro/distro.properties` | Properties |
| Frontend modules | `frontend_config/` | JSON |
| Clinical forms | `ampathforms/` | JSON (O3 form engine schema) |
| Form translations | `ampathformstranslations/` | JSON |
| Concepts / terminology | `concepts/` | CSV |
| Drug database | `drugs/` | CSV |
| Roles & privileges | `roles/` | CSV |
| Address hierarchy | `addresshierarchy/` | CSV |
| ID generation | `idgen/` | CSV |
| Locations | `locations/` | CSV |
| OCL imports | `ocl/` | ZIP (from OpenConceptLab) |

### Overriding a distro configuration at site level

1. Place your override file in the site's `configs/` directory at the same relative path
2. In the site's `pom.xml`, add an `<exclude>` to remove the parent's version:
   ```xml
   <exclude>distro/configs/**/ampathforms/F01-My_Form.json</exclude>
   ```
3. The site's copy is used at build time instead

---

## Clinical Forms

LIME EMR uses the [OpenMRS 3 form engine](https://openmrs.atlassian.net/wiki/spaces/projects/pages/68747273/O3+Form+Docs) with JSON-based form definitions. The distro ships 26 core forms; Mosul extends to 77 forms across all clinical programs.

See the [Forms documentation](forms.md) for the full form list, QA process, and authoring guidelines.

---

## Content Management (Clinical Concepts & Terminology)

Medical concepts — the building blocks of clinical data in OpenMRS — are managed through [OpenConceptLab (OCL)](https://openconceptlab.org/) and loaded via the Initializer module.

### Concept sources

LIME reuses concepts from:
- **CIEL** — Community-curated international concept library
- **MSF OCG** — MSF-specific concepts for programs not covered by CIEL
- **Site-specific** — Concepts unique to a given deployment

### Workflow: adding or updating concepts

**In OpenConceptLab:**
1. Identify reusable concepts from CIEL or the MSF OCG source
2. Create new concepts in the MSF OCG source if none exist
3. Build a collection grouping all concepts needed (per program, per form, or shared)
4. Release the collection and export it as a ZIP file

**In the distribution:**
1. Place the ZIP file in the appropriate `ocl/` configuration directory
2. Restart OpenMRS — the Initializer module loads the concepts automatically
3. Verify concepts are present in the OpenMRS concept dictionary

See the [Content Management documentation](content-management.md) for the full OCL workflow, concept naming conventions, and the UUID generation formula.

---

## Translations

LIME EMR supports Arabic and English across both the clinical UI and form content.

- **Clinical UI** — translated via [Transifex](https://app.transifex.com/openmrs/openmrs3) and the i18next framework
- **Form labels** — translated via OCL concept names; forms leave labels empty to pull from the concept dictionary
- **Form translations** — additional overrides in `ampathformstranslations/` JSON files

See the [Translations documentation](translations.md) for step-by-step guides.

---

## CI/CD Pipeline

The GitHub Actions pipeline builds and deploys automatically on every code change:

- **Push to `main`** → snapshot build → automated deployment to dev → Playwright E2E tests
- **GitHub Release** → production build → deploy to UAT → Playwright E2E tests
- **FiWi production** → manual deployment by an authorized operator (MSF-managed on-premises infrastructure)

All site Docker images are published to [Docker Hub (msfocg)](https://hub.docker.com/r/msfocg).

---

## Data Protection

- **Patient data stays on-premises**: Real patient records exist only on MSF-managed field infrastructure. Patient data is never transmitted to or stored on external cloud infrastructure.
- **Dev and UAT**: These environments run exclusively with synthetic test data. No real patient records.
- **Access control**: Role-based access ensures clinical data is accessible only to authorized healthcare workers at the relevant site.

---

## Contributing

LIME EMR is open source and contributions are welcome:

- **Bug reports & feature requests** → [GitHub Issues](https://github.com/MSF-OCG/LIME-EMR/issues)
- **Pull requests** → branch from `main`, follow existing code style, include tests
- **Clinical content** → coordinate with the MSF OCG application team before adding new forms or concepts

Full contributing guide: [CONTRIBUTING.md](https://github.com/MSF-OCG/LIME-EMR/blob/main/CONTRIBUTING.md)
