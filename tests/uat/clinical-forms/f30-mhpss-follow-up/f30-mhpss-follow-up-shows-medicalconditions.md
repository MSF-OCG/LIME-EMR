---
id: f30-mhpss-follow-up-shows-medicalconditions
title: "F30-MHPSS Follow-up: 11 questions show only when \"Did the patient suffer new critical events since the last consultation?\" is \"Yes\""
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

# F30-MHPSS Follow-up: 11 questions show only when "Did the patient suffer new critical events since the last consultation?" is "Yes"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F30-MHPSS Follow-up"

## Steps

1. Open the form on the page "Events"
2. Answer "Did the patient suffer new critical events since the last consultation?" with "No"
   Expected: "1. Medical conditions", "2. Violence", "3. Separation or loss", "4. Disaster", "5. Other", "Main new precipitating events - 1", "Main new precipitating events - 2", "Main new precipitating events - 3", "Main category of precipitating event", "Time from the main event", "Relevant details of the new precipitating events" stay hidden
3. Answer "Did the patient suffer new critical events since the last consultation?" with "Yes"
   Expected: "1. Medical conditions", "2. Violence", "3. Separation or loss", "4. Disaster", "5. Other", "Main new precipitating events - 1", "Main new precipitating events - 2", "Main new precipitating events - 3", "Main category of precipitating event", "Time from the main event", "Relevant details of the new precipitating events" appear

## Test data

```json
{
  "controller": {
    "id": "didThePatientSufferNewCriticalEventsSinceTheLastConsultation",
    "label": "Did the patient suffer new critical events since the last consultation?"
  },
  "show_with": [
    "Yes"
  ],
  "hide_with": "No",
  "shown": [
    {
      "id": "medicalConditions",
      "label": "1. Medical conditions"
    },
    {
      "id": "violence",
      "label": "2. Violence"
    },
    {
      "id": "separationOrLoss",
      "label": "3. Separation or loss"
    },
    {
      "id": "disaster",
      "label": "4. Disaster"
    },
    {
      "id": "newPrecipitatingEvents_other",
      "label": "5. Other"
    },
    {
      "id": "mainNewPrecipitatingEvents1",
      "label": "Main new precipitating events - 1"
    },
    {
      "id": "mainNewPrecipitatingEvents2",
      "label": "Main new precipitating events - 2"
    },
    {
      "id": "mainNewPrecipitatingEvents3",
      "label": "Main new precipitating events - 3"
    },
    {
      "id": "mainCategoryOfPrecipitatingEvent",
      "label": "Main category of precipitating event"
    },
    {
      "id": "timeFromTheMainEvent",
      "label": "Time from the main event"
    },
    {
      "id": "relevantDetailsOfTheNewPrecipitatingEvents",
      "label": "Relevant details of the new precipitating events"
    }
  ]
}
```

