---
id: f31-mhgap-baseline-shows-setthenextsessiondate
title: "F31-mhGAP Baseline: 2 questions show only when \"Follow-up session required?\" is \"Yes\""
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

# F31-mhGAP Baseline: 2 questions show only when "Follow-up session required?" is "Yes"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F31-mhGAP Baseline"

## Steps

1. Open the form on the page "Follow-up"
2. Answer "Follow-up session required?" with "No"
   Expected: "Set the next session date", "Next session date" stay hidden
3. Answer "Follow-up session required?" with "Yes"
   Expected: "Set the next session date", "Next session date" appear

## Test data

```json
{
  "controller": {
    "id": "followUpSessionRequired",
    "label": "Follow-up session required?"
  },
  "show_with": [
    "Yes"
  ],
  "hide_with": "No",
  "shown": [
    {
      "id": "setTheNextSessionDate",
      "label": "Set the next session date"
    },
    {
      "id": "nextSessionDate",
      "label": "Next session date"
    }
  ]
}
```

