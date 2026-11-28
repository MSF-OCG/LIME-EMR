---
id: f30-mhpss-follow-up-shows-specifymsfhealthfacility
title: "F30-MHPSS Follow-up: \"Specify MSF Health Facility\" shows only when \"Location of intervention\" is \"MSF health facility\""
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

# F30-MHPSS Follow-up: "Specify MSF Health Facility" shows only when "Location of intervention" is "MSF health facility"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F30-MHPSS Follow-up"

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

