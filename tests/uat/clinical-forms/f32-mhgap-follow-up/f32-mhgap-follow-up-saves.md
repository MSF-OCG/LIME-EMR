---
id: f32-mhgap-follow-up-saves
title: F32-mhGAP Follow-up saves with the required questions answered
kind: automated
priority: high
feature: clinical-forms
form: F32-mhGAP Follow-up
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F32-mhGAP_Follow-up_v2.json]
---

# F32-mhGAP Follow-up saves with the required questions answered

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F32-mhGAP Follow-up"

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

