---
id: f30-mhpss-follow-up-shows-pastorprecipitatingevents-ifotherspecify
title: "F30-MHPSS Follow-up: \"If other, specify\" shows only when \"5. Other\" is \"5.4 Other\""
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

# F30-MHPSS Follow-up: "If other, specify" shows only when "5. Other" is "5.4 Other"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F30-MHPSS Follow-up"

## Steps

1. Open the form on the page "Events"
2. Answer "5. Other" with "5.1 Financial problems"
   Expected: "If other, specify" stay hidden
3. Answer "5. Other" with "5.4 Other"
   Expected: "If other, specify" appear

## Test data

```json
{
  "controller": {
    "id": "newPrecipitatingEvents_other",
    "label": "5. Other"
  },
  "show_with": [
    "5.4 Other"
  ],
  "hide_with": "5.1 Financial problems",
  "shown": [
    {
      "id": "pastOrPrecipitatingEvents_ifOtherSpecify",
      "label": "If other, specify"
    }
  ]
}
```

