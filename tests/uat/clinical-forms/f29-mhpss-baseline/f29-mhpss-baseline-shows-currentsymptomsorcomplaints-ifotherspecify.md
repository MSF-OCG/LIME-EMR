---
id: f29-mhpss-baseline-shows-currentsymptomsorcomplaints-ifotherspecify
title: "F29-MHPSS Baseline: \"If other, specify\" shows only when \"8. Other symptoms\" is \"8.1 Other\""
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

# F29-MHPSS Baseline: "If other, specify" shows only when "8. Other symptoms" is "8.1 Other"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F29-MHPSS Baseline"

## Steps

1. Open the form on the page "Problems / symptoms"
2. Answer "8. Other symptoms" with "8.1 Other"
   Expected: "If other, specify" appear

## Test data

```json
{
  "controller": {
    "id": "otherSymptoms",
    "label": "8. Other symptoms"
  },
  "show_with": [
    "8.1 Other"
  ],
  "shown": [
    {
      "id": "currentSymptomsOrComplaints_ifOtherSpecify",
      "label": "If other, specify"
    }
  ]
}
```

