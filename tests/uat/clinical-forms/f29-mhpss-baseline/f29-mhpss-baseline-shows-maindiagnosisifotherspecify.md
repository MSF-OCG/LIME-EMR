---
id: f29-mhpss-baseline-shows-maindiagnosisifotherspecify
title: "F29-MHPSS Baseline: \"Main diagnosis - If other, specify\" shows only when \"Main diagnosis\" is \"Other disorder\""
kind: automated
priority: medium
feature: clinical-forms
form: F29-MHPSS Baseline
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F29-MHPSS_Baseline_v2.json]
---

# F29-MHPSS Baseline: "Main diagnosis - If other, specify" shows only when "Main diagnosis" is "Other disorder"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F29-MHPSS Baseline"

## Steps

1. Open the form on the page "Diagnosis"
2. Answer "Main diagnosis" with "Acute stress reaction"
   Expected: "Main diagnosis - If other, specify" stay hidden
3. Answer "Main diagnosis" with "Other disorder"
   Expected: "Main diagnosis - If other, specify" appear

## Test data

```json
{
  "controller": {
    "id": "mainDiagnosis",
    "label": "Main diagnosis"
  },
  "show_with": [
    "Other disorder"
  ],
  "hide_with": "Acute stress reaction",
  "shown": [
    {
      "id": "mainDiagnosisIfOtherSpecify",
      "label": "Main diagnosis - If other, specify"
    }
  ]
}
```

