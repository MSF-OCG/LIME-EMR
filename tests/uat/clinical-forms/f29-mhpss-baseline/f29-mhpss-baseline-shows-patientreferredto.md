---
id: f29-mhpss-baseline-shows-patientreferredto
title: "F29-MHPSS Baseline: 2 questions show only when \"Referral done?\" is \"Yes\""
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

# F29-MHPSS Baseline: 2 questions show only when "Referral done?" is "Yes"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F29-MHPSS Baseline"

## Steps

1. Open the form on the page "Intervention & follow-up"
2. Answer "Referral done?" with "No"
   Expected: "Patient referred to", "Reason for referral" stay hidden
3. Answer "Referral done?" with "Yes"
   Expected: "Patient referred to", "Reason for referral" appear

## Test data

```json
{
  "controller": {
    "id": "referralDone",
    "label": "Referral done?"
  },
  "show_with": [
    "Yes"
  ],
  "hide_with": "No",
  "shown": [
    {
      "id": "patientReferredTo",
      "label": "Patient referred to"
    },
    {
      "id": "reasonForReferral",
      "label": "Reason for referral"
    }
  ]
}
```

