---
id: f30-mhpss-follow-up-shows-explainthechangeandsetthenewgoal3
title: "F30-MHPSS Follow-up: \"Explain the change and set the new goal 3\" shows only when \"Does any of these previous set goals change\" is \"Goal 3\""
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

# F30-MHPSS Follow-up: "Explain the change and set the new goal 3" shows only when "Does any of these previous set goals change" is "Goal 3"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F30-MHPSS Follow-up"

## Steps

1. Open the form on the page "Intervention & follow-up"
2. Answer "Does any of these previous set goals change" with "Goal 1"
   Expected: "Explain the change and set the new goal 3" stay hidden
3. Answer "Does any of these previous set goals change" with "Goal 3"
   Expected: "Explain the change and set the new goal 3" appear

## Test data

```json
{
  "controller": {
    "id": "doesAnyOfThesePreviousSetGoalsChange",
    "label": "Does any of these previous set goals change"
  },
  "show_with": [
    "Goal 3"
  ],
  "hide_with": "Goal 1",
  "shown": [
    {
      "id": "explainTheChangeAndSetTheNewGoal3",
      "label": "Explain the change and set the new goal 3"
    }
  ]
}
```

