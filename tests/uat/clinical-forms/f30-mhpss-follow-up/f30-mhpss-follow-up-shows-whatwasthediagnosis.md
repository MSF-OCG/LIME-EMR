---
id: f30-mhpss-follow-up-shows-whatwasthediagnosis
title: "F30-MHPSS Follow-up: \"What was the diagnosis\" shows only when \"Was the patient given a diagnosis?\" is \"Yes\""
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

# F30-MHPSS Follow-up: "What was the diagnosis" shows only when "Was the patient given a diagnosis?" is "Yes"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F30-MHPSS Follow-up"

## Steps

1. Open the form on the page "Diagnosis & evolution"
2. Answer "Was the patient given a diagnosis?" with "No"
   Expected: "What was the diagnosis" stay hidden
3. Answer "Was the patient given a diagnosis?" with "Yes"
   Expected: "What was the diagnosis" appear

## Test data

```json
{
  "controller": {
    "id": "wasThePatientGivenADiagnosis",
    "label": "Was the patient given a diagnosis?"
  },
  "show_with": [
    "Yes"
  ],
  "hide_with": "No",
  "shown": [
    {
      "id": "whatWasTheDiagnosis",
      "label": "What was the diagnosis"
    }
  ]
}
```

