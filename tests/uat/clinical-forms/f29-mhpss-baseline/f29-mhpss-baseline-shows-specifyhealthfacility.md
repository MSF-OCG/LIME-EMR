---
id: f29-mhpss-baseline-shows-specifyhealthfacility
title: "F29-MHPSS Baseline: \"Specify Health Facility\" shows only when \"Location of intervention\" is \"Health facility\""
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

# F29-MHPSS Baseline: "Specify Health Facility" shows only when "Location of intervention" is "Health facility"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F29-MHPSS Baseline"

## Steps

1. Open the form on the page "Consultation"
2. Answer "Location of intervention" with "MSF health facility"
   Expected: "Specify Health Facility" stay hidden
3. Answer "Location of intervention" with "Health facility"
   Expected: "Specify Health Facility" appear

## Test data

```json
{
  "controller": {
    "id": "locationOfIntervention",
    "label": "Location of intervention"
  },
  "show_with": [
    "Health facility"
  ],
  "hide_with": "MSF health facility",
  "shown": [
    {
      "id": "specifyHealthFacility",
      "label": "Specify Health Facility"
    }
  ]
}
```

