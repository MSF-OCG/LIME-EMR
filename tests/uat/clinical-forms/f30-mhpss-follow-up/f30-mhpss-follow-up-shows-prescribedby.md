---
id: f30-mhpss-follow-up-shows-prescribedby
title: "F30-MHPSS Follow-up: \"Prescribed by\" shows only when \"Is the patient currently on psychotropic medication?\" is \"Yes\""
kind: automated
priority: medium
feature: clinical-forms
form: F30-MHPSS Follow-up
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F30-MHPSS_Follow-up_v2.json]
---

# F30-MHPSS Follow-up: "Prescribed by" shows only when "Is the patient currently on psychotropic medication?" is "Yes"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F30-MHPSS Follow-up"

## Steps

1. Open the form on the page "Diagnosis & evolution"
2. Answer "Is the patient currently on psychotropic medication?" with "No"
   Expected: "Prescribed by" stay hidden
3. Answer "Is the patient currently on psychotropic medication?" with "Yes"
   Expected: "Prescribed by" appear

## Test data

```json
{
  "controller": {
    "id": "isThePatientCurrentlyOnPsychotropicMedication",
    "label": "Is the patient currently on psychotropic medication?"
  },
  "show_with": [
    "Yes"
  ],
  "hide_with": "No",
  "shown": [
    {
      "id": "prescribedBy",
      "label": "Prescribed by"
    }
  ]
}
```

