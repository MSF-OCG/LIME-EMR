---
id: f29-mhpss-baseline-shows-specifymsfhealthfacility
title: "F29-MHPSS Baseline: \"Specify MSF Health Facility\" shows only when \"Location of intervention\" is \"MSF health facility\""
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

# F29-MHPSS Baseline: "Specify MSF Health Facility" shows only when "Location of intervention" is "MSF health facility"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F29-MHPSS Baseline"

## Steps

1. Open the form on the page "Consultation"
2. Answer "Location of intervention" with "Health facility"
   Expected: "Specify MSF Health Facility" stay hidden
3. Answer "Location of intervention" with "MSF health facility"
   Expected: "Specify MSF Health Facility" appear

## Test data

```json
{
  "controller": {
    "id": "locationOfIntervention",
    "label": "Location of intervention"
  },
  "show_with": [
    "MSF health facility"
  ],
  "hide_with": "Health facility",
  "shown": [
    {
      "id": "specifyMsfHealthFacility",
      "label": "Specify MSF Health Facility"
    }
  ]
}
```

