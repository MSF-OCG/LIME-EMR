---
id: f31-mhgap-baseline-opens
title: F31-mhGAP Baseline opens on every page
kind: automated
priority: high
feature: clinical-forms
form: F31-mhGAP Baseline
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
locales: [en]
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F31-mhGAP_Baseline_v2.json]
---

# F31-mhGAP Baseline opens on every page

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F31-mhGAP Baseline"

## Steps

1. Open the patient chart and start "F31-mhGAP Baseline" from Clinical forms
   Expected: The form opens without an error
2. Go to the page "File information"
   Expected: The page shows "Checklist reminder", "Referral source", "Consultation information"
3. Go to the page "History"
   Expected: The page shows "Motive for consultation", "Present", "Past", "Family", "Conditions", "Special Populations"
4. Go to the page "Examination"
   Expected: The page shows "Examination"
5. Go to the page "Scores"
   Expected: The page shows "MHOS - In the past week:", "MHOS", "PHQ9 - Over the last two weeks, how often have you been bothered by any of the following problems?", "PHQ9", "Depression severity scale", "Last PHQ9 score", "GAD7 - Over the last two weeks, how often have you been bothered by any of the following problems?", "GAD7 score", "Last GAD7 score", "CGI"
6. Go to the page "Diagnosis"
   Expected: The page shows "Clinical diagnosis"
7. Go to the page "Medication"
   Expected: The page shows "Medication"
8. Go to the page "Observations"
   Expected: The page shows "Observations"
9. Go to the page "Follow-up"
   Expected: The page shows "Follow-up"

## Test data

```json
{
  "pages": [
    "File information",
    "History",
    "Examination",
    "Scores",
    "Diagnosis",
    "Medication",
    "Observations",
    "Follow-up"
  ]
}
```

