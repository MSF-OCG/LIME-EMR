---
id: f32-mhgap-follow-up-shows-setthenextsessiondate
title: "F32-mhGAP Follow-up: 2 questions show only when \"Follow up session required? (If no, fill the Exit form)\" is \"Yes\""
kind: automated
priority: medium
feature: clinical-forms
form: F32-mhGAP Follow-up
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F32-mhGAP_Follow-up_v2.json]
---

# F32-mhGAP Follow-up: 2 questions show only when "Follow up session required? (If no, fill the Exit form)" is "Yes"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F32-mhGAP Follow-up"

## Steps

1. Open the form on the page "Follow-up"
2. Answer "Follow up session required? (If no, fill the Exit form)" with "No"
   Expected: "Set the next session date", "Next session date" stay hidden
3. Answer "Follow up session required? (If no, fill the Exit form)" with "Yes"
   Expected: "Set the next session date", "Next session date" appear

## Test data

```json
{
  "controller": {
    "id": "followUpSessionRequired",
    "label": "Follow up session required? (If no, fill the Exit form)"
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

