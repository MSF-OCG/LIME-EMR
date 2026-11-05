---
id: f29-mhpss-baseline-shows-ifyesenterdetailsinmedications
title: "F29-MHPSS Baseline: \"If yes, enter details in 'Medications'\" shows only when \"Was the patient prescribed psychotropic medication?\" is \"Previously\" or \"Yes, currently\""
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

# F29-MHPSS Baseline: "If yes, enter details in 'Medications'" shows only when "Was the patient prescribed psychotropic medication?" is "Previously" or "Yes, currently"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F29-MHPSS Baseline"

## Steps

1. Open the form on the page "History"
2. Answer "Was the patient prescribed psychotropic medication?" with "Never"
   Expected: "If yes, enter details in 'Medications'" stay hidden
3. Answer "Was the patient prescribed psychotropic medication?" with "Previously"
   Expected: "If yes, enter details in 'Medications'" appear
4. Change the answer to "Yes, currently"
   Expected: "If yes, enter details in 'Medications'" still show

## Test data

```json
{
  "controller": {
    "id": "wasThePatientPrescribedPsychotropicMedication",
    "label": "Was the patient prescribed psychotropic medication?"
  },
  "show_with": [
    "Previously",
    "Yes, currently"
  ],
  "hide_with": "Never",
  "shown": [
    {
      "id": "ifYesEnterDetailsInmedications",
      "label": "If yes, enter details in 'Medications'"
    }
  ]
}
```

