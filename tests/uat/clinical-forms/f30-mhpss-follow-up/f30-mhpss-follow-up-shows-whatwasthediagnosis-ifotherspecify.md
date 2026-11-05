---
id: f30-mhpss-follow-up-shows-whatwasthediagnosis-ifotherspecify
title: "F30-MHPSS Follow-up: \"If other, specify\" shows only when \"What was the diagnosis\" is \"Other disorder\""
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

# F30-MHPSS Follow-up: "If other, specify" shows only when "What was the diagnosis" is "Other disorder"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F30-MHPSS Follow-up"

## Steps

1. Open the form on the page "Diagnosis & evolution"
2. Answer "What was the diagnosis" with "Acute stress reaction"
   Expected: "If other, specify" stay hidden
3. Answer "What was the diagnosis" with "Other disorder"
   Expected: "If other, specify" appear

## Test data

```json
{
  "controller": {
    "id": "whatWasTheDiagnosis",
    "label": "What was the diagnosis"
  },
  "show_with": [
    "Other disorder"
  ],
  "hide_with": "Acute stress reaction",
  "shown": [
    {
      "id": "whatWasTheDiagnosis_ifOtherSpecify",
      "label": "If other, specify"
    }
  ]
}
```

