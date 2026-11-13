---
id: f30-mhpss-follow-up-opens
title: F30-MHPSS Follow-up opens on every page
kind: automated
priority: high
feature: clinical-forms
form: F30-MHPSS Follow-up
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
locales: [en]
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F30-MHPSS_Follow-up_v2.json]
---

# F30-MHPSS Follow-up opens on every page

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F30-MHPSS Follow-up"

## Steps

1. Open the patient chart and start "F30-MHPSS Follow-up" from Clinical forms
   Expected: The form opens without an error
2. Go to the page "Consultation"
   Expected: The page shows "Consultation information", "Missed session"
3. Go to the page "Diagnosis & evolution"
   Expected: The page shows "Evolution", "Clinical diagnosis", "Medication"
4. Go to the page "Risk factors"
   Expected: The page shows "Consider referral to mhGAP/psychologist"
5. Go to the page "Events"
   Expected: The page shows "New precipitating events (possible reasons or causes linked to current problem)", "Select the main events prioritized as 1, 2 and 3 from the lists", "Details of events"
6. Go to the page "Scores"
   Expected: The page shows "MHOS - In the past week:", "MHOS", "PHQ9 - Over the last two weeks, how often have you been bothered by any of the following problems?", "PHQ9", "Depression severity scale", "Last PHQ9 score", "GAD7 - Over the last two weeks, how often have you been bothered by any of the following problems?", "GAD7 score", "Last GAD7 score", "CGI - Clinical Global Impression"
7. Go to the page "Intervention & follow-up"
   Expected: The page shows "Goals progress status", "Change in goal", "Intervention", "Follow-up"

## Test data

```json
{
  "pages": [
    "Consultation",
    "Diagnosis & evolution",
    "Risk factors",
    "Events",
    "Scores",
    "Intervention & follow-up"
  ]
}
```

