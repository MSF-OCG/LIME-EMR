# Content Management

Clinical content in LIME EMR — concepts, drug lists, terminology, and metadata — is managed through [OpenConceptLab (OCL)](https://openconceptlab.org/) and loaded into OpenMRS via the [Initializer module](https://github.com/mekomsolutions/openmrs-module-initializer). No manual database imports are required.

---

## Overview

```
OpenConceptLab (OCL)
  ├── CIEL source         (international standard concepts)
  ├── MSF OCG source      (MSF-specific concepts)
  └── Collections         (per program / per form groupings)
         │
         │  Export as ZIP
         ▼
  configs/ocl/*.zip       (checked into the repository)
         │
         │  Initializer loads on startup
         ▼
  OpenMRS Concept Dictionary
```

---

## Concept Sources

| Source | Description | When to use |
|--------|-------------|-------------|
| **CIEL** | Community-curated international EMR concept library | First choice — reuse existing standard concepts |
| **MSF OCG** | MSF-specific concepts not covered by CIEL | When no CIEL concept exists for a clinical need |
| **Site-specific** | Concepts unique to one deployment | Rare — only when a concept cannot be generalized |

> Always prefer CIEL over creating new concepts. New MSF OCG concepts must be reviewed by the clinical team before use.

---

## Workflow: Adding or Updating Concepts

### Step 1 — Define the clinical need

Before creating concepts, identify:
- What clinical question needs to be answered?
- Does a suitable concept already exist in CIEL or MSF OCG?
- Is this concept shared across multiple forms or programs, or form-specific?

### Step 2 — Search existing sources

1. Log in to [OpenConceptLab](https://openconceptlab.org/) with your MSF OCG account
2. Search the CIEL source for an existing concept
3. If found: add it to your collection (Step 3)
4. If not found: create a new concept in the MSF OCG source (Step 2b)

### Step 2b — Create a new concept (if needed)

1. Navigate to the [MSF OCG source](https://app.openconceptlab.org/#/orgs/MSFOCG/) in OCL
2. Create the concept with:
   - A clear, standardized English name
   - Arabic translation (if applicable)
   - Correct data type (Coded, Text, Numeric, Boolean, Date, etc.)
   - Answer concepts if data type is Coded
   - Mappings to CIEL or ICD if available
3. Assign a UUID (see [UUID generation](#uuid-generation) below)

### Step 3 — Build or update a collection

Collections group the concepts needed for a given implementation:

1. Open or create a collection in OCL (e.g., `lime-mosul-mental-health`)
2. Add all required concepts to the collection
3. Organize by program or form for maintainability

### Step 4 — Release and export

1. Create a new release version of the collection in OCL
2. Export the release as a ZIP file
3. Download the ZIP

### Step 5 — Add to the distribution

1. Place the ZIP file in the appropriate configuration directory:
   ```
   distro/configs/openmrs/initializer_config/ocl/    # for distro-level concepts
   sites/<site>/configs/openmrs/initializer_config/ocl/    # for site-specific concepts
   ```
2. Commit the ZIP file to the repository
3. Build and restart OpenMRS — the Initializer loads the concepts automatically:
   ```bash
   ./scripts/mvnw clean package
   # then start the relevant site or distro
   ```
4. Verify concepts appear in the OpenMRS concept dictionary (Admin → Concept Dictionary)

---

## Workflow: Form-Concept Mapping

Forms reference concepts by UUID. When building or updating a form:

1. Ensure all required concepts are present in the concept dictionary before referencing them
2. Use the concept UUID in the form JSON (`conceptMappings` or `concept` field)
3. Leave form labels empty where possible — they will be pulled from the concept's name in the dictionary, supporting automatic multilingual rendering

---

## UUID Generation

When creating new concepts manually, a valid UUID v4 is required. Use this Excel formula to generate one:

```
=LOWER(CONCATENATE(
  DEC2HEX(RANDBETWEEN(0,POWER(16,8)),8),"-",
  DEC2HEX(RANDBETWEEN(0,POWER(16,4)),4),"-",
  "4",DEC2HEX(RANDBETWEEN(0,POWER(16,3)),3),"-",
  DEC2HEX(RANDBETWEEN(8,11)),DEC2HEX(RANDBETWEEN(0,POWER(16,3)),3),"-",
  DEC2HEX(RANDBETWEEN(0,POWER(16,8)),8),DEC2HEX(RANDBETWEEN(0,POWER(16,4)),4)
))
```

Or use any standard UUID v4 generator (e.g., `uuidgen` on Linux/macOS).

> **Important:** Never reuse UUIDs across concepts. A UUID assigned to a concept is permanent — changing it after deployment will break existing patient records.

---

## Drug List Management

The drug database is maintained as CSV files in `configs/openmrs/initializer_config/drugs/` and loaded by the Initializer module.

To add or update drugs:
1. Edit the CSV file at the appropriate level (distro or site)
2. Include: drug name, concept UUID, dosage form, strength, route, units
3. Build and restart to apply

> Drug lists for each site are maintained separately from the distro base list. Site-specific drugs go in the site-level `drugs/` directory.

---

## References

- [OpenConceptLab (OCL)](https://openconceptlab.org/) — concept authoring and management platform
- [LIME Demo OCL collection](https://app.openconceptlab.org/#/orgs/MSFOCG/collections/lime-demo/) — base collection used in the distro
- [OpenMRS Initializer module](https://github.com/mekomsolutions/openmrs-module-initializer) — loads all configuration on startup
- [CIEL concept dictionary](https://openconceptlab.org/orgs/CIEL/) — primary source for international standard concepts
- [O3 Form Engine schema](https://openmrs.atlassian.net/wiki/spaces/projects/pages/68747273/O3+Form+Docs) — form authoring reference
