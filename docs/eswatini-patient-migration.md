# Eswatini patient migration (OpenFn scaffold)

Draft workflow for [issue #342](https://github.com/MSF-OCG/LIME-EMR/issues/342): import spreadsheet/JSON patient records into OpenMRS via OpenFn.

## Status

**Scaffold only.** Open questions OMRS-01 through OMRS-06 in the issue must be confirmed before production use.

## Workflow file

- `sites/matsapha/configs/openfn/eswatini-patient-migration.yaml`
- Merged into `openfn-project.yaml` at build time with other Matsapha workflow YAML files.

## Placeholders to replace

| Placeholder | Purpose |
|-------------|---------|
| `PLACEHOLDER_IDENTIFIER_SOURCE_UUID` | OpenMRS idgen source for new patient IDs |
| `PLACEHOLDER_AUTO_IDENTIFIER_TYPE_UUID` | Preferred auto-generated identifier type |
| `PLACEHOLDER_LEGACY_IDENTIFIER_TYPE_UUID` | Legacy / Old Patient ID identifier type |
| `PLACEHOLDER_DEFAULT_LOCATION_UUID` | Default location for new identifiers |

Update the OpenMRS credential reference (`michael.bontyes@geneva.msf.org-openmrs`) to the Matsapha deployment credential name in `projectState.json` when enabling this workflow.

## Trigger (not wired yet)

Issue #342 supports:

1. Excel upload (manual job run with payload), or
2. Webhook with JSON array body

Add a `triggers` / `edges` section in the YAML once the trigger type is chosen (OMRS-01).

## Behaviour (aligned with issue recommendations)

- Deduplication: exact match on **Old Patient ID**; **fail record** if multiple matches.
- Gender: maps Male/Female/Nonbinary/Unknown to OpenMRS codes; extend after OMRS-03.
- Failure handling: invalid rows fail validation; per-patient OpenMRS errors are logged in `results.failed`; batch continues (OMRS-06).

## Pre-development checklist

See the checklist in issue #342 (credentials, UUIDs, gender rules, batch size, staging validation).

## Related

- Mosul WF1 `Create-Patients` job — reference for idgen + POST patient patterns.
- Issue #250 — OpenFn collections loading for metadata (separate from this migration workflow).
