---
id: f29-mhpss-baseline-shows-whatwasthediagnosis
title: "F29-MHPSS Baseline: 2 questions show only when \"Does the patient have a previous mental disorder diagnosis?\" is \"Yes\""
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

# F29-MHPSS Baseline: 2 questions show only when "Does the patient have a previous mental disorder diagnosis?" is "Yes"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F29-MHPSS Baseline"

## Steps

1. Open the form on the page "History"
2. Answer "Does the patient have a previous mental disorder diagnosis?" with "No"
   Expected: "What was the diagnosis", "Was the patient prescribed psychotropic medication?" stay hidden
3. Answer "Does the patient have a previous mental disorder diagnosis?" with "Yes"
   Expected: "What was the diagnosis", "Was the patient prescribed psychotropic medication?" appear

## Test data

```json
{
  "controller": {
    "id": "doesThePatientHaveAPreviousMentalDisorderDiagnosis",
    "label": "Does the patient have a previous mental disorder diagnosis?"
  },
  "show_with": [
    "Yes"
  ],
  "hide_with": "No",
  "shown": [
    {
      "id": "whatWasTheDiagnosis",
      "label": "What was the diagnosis"
    },
    {
      "id": "wasThePatientPrescribedPsychotropicMedication",
      "label": "Was the patient prescribed psychotropic medication?"
    }
  ]
}
```

