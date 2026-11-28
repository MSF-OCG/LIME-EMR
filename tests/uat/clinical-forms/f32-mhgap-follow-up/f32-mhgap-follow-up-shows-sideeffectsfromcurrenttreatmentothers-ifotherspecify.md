---
id: f32-mhgap-follow-up-shows-sideeffectsfromcurrenttreatmentothers-ifotherspecify
title: "F32-mhGAP Follow-up: \"If other, specify\" shows only when \"Others\" is \"Other\""
kind: automated
priority: medium
feature: clinical-forms
form: F32-mhGAP Follow-up
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F32-mhGAP_Follow-up_v2.json]
---

# F32-mhGAP Follow-up: "If other, specify" shows only when "Others" is "Other"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F32-mhGAP Follow-up"

## Steps

1. Open the form on the page "Medication"
2. Answer "Others" with "Anticholinergic"
   Expected: "If other, specify" stay hidden
3. Answer "Others" with "Other"
   Expected: "If other, specify" appear

## Test data

```json
{
  "controller": {
    "id": "sideEffectsFromCurrentTreatmentOthers",
    "label": "Others"
  },
  "show_with": [
    "Other"
  ],
  "hide_with": "Anticholinergic",
  "shown": [
    {
      "id": "sideEffectsFromCurrentTreatmentOthers_ifOtherSpecify",
      "label": "If other, specify"
    }
  ]
}
```

