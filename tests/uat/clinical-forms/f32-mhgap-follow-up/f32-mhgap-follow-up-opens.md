---
id: f32-mhgap-follow-up-opens
title: F32-mhGAP Follow-up opens on every page
kind: automated
priority: high
feature: clinical-forms
form: F32-mhGAP Follow-up
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
locales: [en]
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F32-mhGAP_Follow-up_v2.json]
---

# F32-mhGAP Follow-up opens on every page

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F32-mhGAP Follow-up"

## Steps

1. Open the patient chart and start "F32-mhGAP Follow-up" from Clinical forms
   Expected: The form opens without an error
2. Go to the page "Consultation"
   Expected: The page shows "mhGAP forms are to be filled only by mhGAP clinician (Clinical officer / GP / nurse trained in mhGAP / psychiatrist)", "Missed session"
3. Go to the page "Examination"
   Expected: The page shows "Examination", "Evolution"
4. Go to the page "Medication"
   Expected: The page shows "Side effects to the current treatment", "Observations", "Adherence to treatment"
5. Go to the page "Scores"
   Expected: The page shows "MHOS - In the past week:", "MHOS", "PHQ9 - Over the last two weeks, how often have you been bothered by any of the following problems?", "PHQ9", "Depression severity scale", "Last PHQ9 score", "GAD7 - Over the last two weeks, how often have you been bothered by any of the following problems?", "GAD7 score", "Last GAD7 score", "CGI - Clinical Global Impression"
6. Go to the page "Diagnosis & prescription"
   Expected: The page shows "Diagnosis", "Medication"
7. Go to the page "Follow-up"
   Expected: The page shows "Follow-up"

## Test data

```json
{
  "pages": [
    "Consultation",
    "Examination",
    "Medication",
    "Scores",
    "Diagnosis & prescription",
    "Follow-up"
  ]
}
```

