# Changelog

All notable changes to the OpenFn Mosul configuration are documented here.

[UAT Testbook](https://docs.google.com/spreadsheets/d/13yjqiejKFf6HlNCvgfgaKNi9Gffhq22RUTwXKUPR36k/edit?gid=2075335540#gid=2075335540)

**Supported OMRS Versions:**

- F29-MHPSS Baseline v2, F30-MHPSS Follow-up v2, F31-mhGAP Baseline v2, F32-mhGAP Follow-up v2, F33-MHPSS Closure v2, F34-mhGAP Closure v2, F00-Registration

---

## [v1.5.3] - 2026-02-24

**Type:** Enhancement | **PR:** [#363](https://github.com/MSF-OCG/LIME-EMR/pull/363)

- Removes pii attributes before creating a tracker in DHIS2 for Mental Health program in wf2.

**Metadata:** LIME EMR - Iraq Metadata - Release 1 - v2026-01-28
**OMRS Forms:** v2-2025

---

## [v1.5.2] - 2026-01-30

**Type:** Bug Fix | **PR:** [#344](https://github.com/MSF-OCG/LIME-EMR/pull/344)

- Fix bug with mappings for CGI-S, Location of Intervention, and OccupationDescription

**Metadata:** LIME EMR - Iraq Metadata - Release 1 - v2026-01-28
**OMRS Forms:** v2-2025

---

## [v1.5.1] - 2025-10-13

**Type:** Bug Fix | **PR:** [#280](https://github.com/MSF-OCG/LIME-EMR/pull/280)

- Fix a bug causing old forms to be overridden whenever they were synced to DHIS2

**Metadata:** LIME EMR - Iraq Metadata - Release 1 - v2025-09-25
**OMRS Forms:** v2-2025

---

## [v1.5] - 2025-10-07

**PR Created:** 2025-10-06 | **Type:** Bug Fix | **PR:** [#273](https://github.com/MSF-OCG/LIME-EMR/pull/273)

- Fix bugs and missing custom mapping logic on WF1 and WF2 reported from UAT
- Optimize the metadata.json to remove unused properties and reduce the size of the metadata file

**Notes:** Address UAT feedback
**Metadata:** LIME EMR - Iraq Metadata - Release 1 - v2025-09-25
**OMRS Forms:** v2-2025

---

## [v1.4] - 2025-09-17

**PR Created:** 2025-09-17 | **Type:** Bug Fix | **PR:** [#268](https://github.com/MSF-OCG/LIME-EMR/pull/268)

- Fix a bug on WF1 where some attributes were being sent in both `patient.person.attributes[]` and `patient.person`, causing an error in OpenMRS because some of those attributes did not exist
- Optimize the metadata.json to remove unused properties and reduce the size of the metadata file
- Remove unused properties in the encounter and patient objects passed to downstream jobs

**Notes:** Bugfix for WF1 and metadata optimization to reduce the size of the mapping
**Metadata:** LIME EMR - Iraq Metadata - Release 1 - v2025-09-06
**OMRS Forms:** v2-2025

---

## [v1.3] - 2025-09-10

**PR Created:** 2025-09-07 | **Type:** Bug Fix | **PR:** [#260](https://github.com/MSF-OCG/LIME-EMR/pull/260)

- Handle erroneous mappings caused by duplicate external IDs
- Introduced the concept of question-IDs in the mappings generated from the metadata file
- Use the question IDs throughout WF2 to uniquely identify an external ID in OMRS

**Notes:** Major change in how the metadata mapping file is generated and used
**Metadata:** LIME EMR - Iraq Metadata - Release 1 - v2025-09-05
**OMRS Forms:** v2-2025

---

## [v1.2.1] - 2025-07-22

**PR Created:** 2025-07-17 | **Type:** Bug Fix | **PR:** [#212](https://github.com/MSF-OCG/LIME-EMR/pull/212)

- Edit WF2 to enable dynamic implementation of syncing latest encounters for a patient for baseline and closure forms
- Sync latest forms for follow-up forms

**Notes:** Add logic to sync latest encounters for some forms and all encounters for other forms
**Metadata:** LIME EMR - Iraq Metadata - Release 1 - v2025-07-14
**OMRS Forms:** v2-2025

---

## [v1.2.0] - 2025-07-01

**PR Created:** 2025-06-11 | **Type:** Enhancement | **PR:** [#191](https://github.com/MSF-OCG/LIME-EMR/pull/191)

- Support for custom logic for forms:
  - F29-MHPSS Baseline v2
  - F30-MHPSS Follow-up v2
  - F31-mhGAP Baseline v2
  - F32-mhGAP Follow-up v2
  - F33-MHPSS Closure v2
  - F34-mhGAP Closure v2

**Notes:** To support the newly added OMRS forms and their custom logic
**Metadata:** LIME EMR - Iraq Metadata - Release 1 - v2025-06-23
**OMRS Forms:** v1-2024 and v2-2025

---

## [v0.8] - 2025-04-22

**PR Created:** 2025-04-03 | **Type:** Enhancement | **PR:** [#136](https://github.com/MSF-OCG/LIME-EMR/pull/136)

- WF1: Skip syncing TEIs that already originated from OMRS (based on existing OMRS ID)

**Notes:** Addresses issue where duplicate records were created in testing environments. Ensures WF1 does not sync patients created in OMRS back to OMRS in the event WF2 does not complete or testing data is reset
**Metadata:** LIME EMR - Iraq Metadata - Release 1 - v2024-01-21
**OMRS Forms:** v1-2024

---

## [v0.7] - 2025-03-18

**PR Created:** 2025-03-14 | **Type:** Enhancement | **PR:** [#108](https://github.com/MSF-OCG/LIME-EMR/pull/108)

- WF1: Handle duplicate TEIs detected in DHIS2

**Notes:** Implements error handling if duplicate TEIs are detected in DHIS2 and filters them out before importing patients to OpenMRS. Addresses data quality issues in DHIS2
**Metadata:** LIME EMR - Iraq Metadata - Release 1 - v2024-01-21
**OMRS Forms:** v1-2024

---

## [v0.6] - 2025-01-31

**PR Created:** 2025-01-24 | **Type:** Enhancement | **PR:** [#89](https://github.com/MSF-OCG/LIME-EMR/pull/89)

- Update OpenFn config to use one source of truth across DEV, UAT, and FIWI environments

**Notes:** Simplifies the OpenFn deployment process by ensuring a consistent `projectState.json` file across deployments
**Metadata:** LIME EMR - Iraq Metadata - Release 1 - v2024-01-21
**OMRS Forms:** v1-2024

---

## [v0.5] - 2025-01-23

**PR Created:** 2025-01-18 | **Type:** Enhancement | **PR:** [#87](https://github.com/MSF-OCG/LIME-EMR/pull/87)

- WF1: Add default gender "U" when importing patients to OMRS if no `patient.sex` is provided in DHIS2 source data

**Notes:** Fix to unblock testing and address potential data quality issues
**Metadata:** LIME EMR - Iraq Metadata - Release 1
**OMRS Forms:** v1-2024

---

## [v0.4] - 2025-01-17

**PR Created:** 2025-01-12 | **Type:** Bug Fix | **PR:** [#86](https://github.com/MSF-OCG/LIME-EMR/pull/86)

- Patch to `run_msf_addons.sh` to address WF2 error: unexpected relative URL

**Notes:** Temporary fix for WF2 Get Encounters step to unblock local testing (caused by OMRS credential issue)
**Metadata:** LIME EMR - Iraq Metadata - Release 1
**OMRS Forms:** v1-2024

---

## [v0.3] - 2025-01-10

**PR Created:** 2024-12-19 | **Type:** Bug Fix | **PR:** [#84](https://github.com/MSF-OCG/LIME-EMR/pull/84)

- WF1 failure fix: Updated OMRS ExternalIds from the metadata mapping

**Notes:** Refreshed the `mapping.json` after correcting ExternalIds in the metadata file for OMRS questions that were causing WF1 to fail
**Metadata:** LIME EMR - Iraq Metadata - Release 1
**OMRS Forms:** v1-2024

---

## [v0.2] - 2024-12-18

**PR Created:** 2024-12-13 | **Type:** Bug Fix | **PR:** [#82](https://github.com/MSF-OCG/LIME-EMR/pull/82)

- Warm OpenFn cache to allow full offline support

**Notes:** Addresses bug with OpenFn adaptors loading and Monaco editor in a fully offline environment
**Metadata:** LIME EMR - Iraq Metadata - Release 1
**OMRS Forms:** v1-2024

---

## [v0.1] - 2024-12-12

**PR Created:** 2024-12-04 | **Type:** Feature (UAT Release) | **PR:** [#80](https://github.com/MSF-OCG/LIME-EMR/pull/80)

- UAT release: Tested OpenFn msf-lime-mosul project configuration (with WF1 and WF2) ready for local deployment and testing in DEV and UAT environments

**Notes:** `project.yaml` export that has passed OFG cloud testing and is for testing on MSF's locally deployed test environments
**Metadata:** LIME EMR - Iraq Metadata - Release 1
**OMRS Forms:** v1-2024
