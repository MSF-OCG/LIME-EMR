---
id: f30-mhpss-follow-up-shows-reasonformissedappointment-ifotherspecify
title: "F30-MHPSS Follow-up: \"If other, specify\" shows only when \"Reason for missed appointment\" is \"Other\""
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

# F30-MHPSS Follow-up: "If other, specify" shows only when "Reason for missed appointment" is "Other"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F30-MHPSS Follow-up"

## Steps

1. Open the form on the page "Consultation"
2. Answer "Reason for missed appointment" with "Patient forgot about session"
   Expected: "If other, specify" stay hidden
3. Answer "Reason for missed appointment" with "Other"
   Expected: "If other, specify" appear

## Test data

```json
{
  "controller": {
    "id": "reasonForMissedAppointment",
    "label": "Reason for missed appointment"
  },
  "show_with": [
    "Other"
  ],
  "hide_with": "Patient forgot about session",
  "shown": [
    {
      "id": "reasonForMissedAppointment_ifOtherSpecify",
      "label": "If other, specify"
    }
  ]
}
```

