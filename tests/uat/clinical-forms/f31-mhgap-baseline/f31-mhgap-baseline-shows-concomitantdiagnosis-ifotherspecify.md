---
id: f31-mhgap-baseline-shows-concomitantdiagnosis-ifotherspecify
title: "F31-mhGAP Baseline: \"If other, specify\" shows only when \"Concomitant diagnosis\" is \"Other disorder\""
kind: automated
priority: medium
feature: clinical-forms
form: F31-mhGAP Baseline
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F31-mhGAP_Baseline_v2.json]
---

# F31-mhGAP Baseline: "If other, specify" shows only when "Concomitant diagnosis" is "Other disorder"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F31-mhGAP Baseline"

## Steps

1. Open the form on the page "Diagnosis"
2. Answer "Concomitant diagnosis" with "Acute stress reaction"
   Expected: "If other, specify" stay hidden
3. Answer "Concomitant diagnosis" with "Other disorder"
   Expected: "If other, specify" appear

## Test data

```json
{
  "controller": {
    "id": "concomitantDiagnosis",
    "label": "Concomitant diagnosis"
  },
  "show_with": [
    "Other disorder"
  ],
  "hide_with": "Acute stress reaction",
  "shown": [
    {
      "id": "concomitantDiagnosis_ifOtherSpecify",
      "label": "If other, specify"
    }
  ]
}
```

