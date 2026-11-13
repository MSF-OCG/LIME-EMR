---
id: f30-mhpss-follow-up-shows-numberofappointmentsmissed
title: "F30-MHPSS Follow-up: 3 questions show only when \"Did the patient miss the session?\" is \"Yes\""
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

# F30-MHPSS Follow-up: 3 questions show only when "Did the patient miss the session?" is "Yes"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F30-MHPSS Follow-up"

## Steps

1. Open the form on the page "Consultation"
2. Answer "Did the patient miss the session?" with "No"
   Expected: "Number of appointments missed", "Patient rescheduled (if Yes, fill the Follow-up section at the end of this form. If No, fill the Exit form.)", "Reason for missed appointment" stay hidden
3. Answer "Did the patient miss the session?" with "Yes"
   Expected: "Number of appointments missed", "Patient rescheduled (if Yes, fill the Follow-up section at the end of this form. If No, fill the Exit form.)", "Reason for missed appointment" appear

## Test data

```json
{
  "controller": {
    "id": "didThePatientMissTheSession",
    "label": "Did the patient miss the session?"
  },
  "show_with": [
    "Yes"
  ],
  "hide_with": "No",
  "shown": [
    {
      "id": "numberOfAppointmentsMissed",
      "label": "Number of appointments missed"
    },
    {
      "id": "patientRescheduled",
      "label": "Patient rescheduled (if Yes, fill the Follow-up section at the end of this form. If No, fill the Exit form.)"
    },
    {
      "id": "reasonForMissedAppointment",
      "label": "Reason for missed appointment"
    }
  ]
}
```

