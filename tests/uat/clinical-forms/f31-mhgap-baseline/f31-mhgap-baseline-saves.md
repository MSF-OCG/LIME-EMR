---
id: f31-mhgap-baseline-saves
title: F31-mhGAP Baseline saves with the required questions answered
kind: automated
priority: high
feature: clinical-forms
form: F31-mhGAP Baseline
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F31-mhGAP_Baseline_v2.json]
---

# F31-mhGAP Baseline saves with the required questions answered

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F31-mhGAP Baseline"

## Steps

1. Open the form
   Expected: The form opens
2. Click Save
   Expected: A confirmation says the form was saved
3. Open the visit in the patient chart
   Expected: A "Mental Health" encounter shows the answers given

## Test data

```json
{
  "fill": [],
  "encounter_type": "95d68645-1b72-4290-be0b-ec1fb64bc067"
}
```

