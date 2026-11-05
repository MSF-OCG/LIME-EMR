---
id: f29-mhpss-baseline-opens
title: F29-MHPSS Baseline opens on every page
kind: automated
priority: high
feature: clinical-forms
form: F29-MHPSS Baseline
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
locales: [en]
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F29-MHPSS_Baseline_v2.json]
---

# F29-MHPSS Baseline opens on every page

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F29-MHPSS Baseline"

## Steps

1. Open the patient chart and start "F29-MHPSS Baseline" from Clinical forms
   Expected: The form opens without an error
2. Go to the page "Consultation"
   Expected: The page shows "File information", "Demographics", "Knowledge", "Referral source"
3. Go to the page "History"
   Expected: The page shows "Motive of consultation", "History of Mental Disorder"
4. Go to the page "Risk factors"
   Expected: The page shows "Consider referral to mhGAP/psychologist"
5. Go to the page "Resilience and coping"
   Expected: The page shows "Resilience and coping"
6. Go to the page "Problems / symptoms"
   Expected: The page shows "Current symptoms or complaints", "Select the main problems prioritized as 1, 2 and 3 from the lists", "Current MH condition"
7. Go to the page "Scores"
   Expected: The page shows "MHOS - In the past week:", "MHOS", "CGI", "PHQ9 - Over the last two weeks, how often have you been bothered by any of the following problems?", "PHQ9", "Depression severity scale", "Last PHQ9 score", "GAD7 - Over the last two weeks, how often have you been bothered by any of the following problems?", "GAD7 score", "Last GAD7 score"
8. Go to the page "Diagnosis"
   Expected: The page shows "Clinical diagnosis"
9. Go to the page "Events"
   Expected: The page shows "Past / precipitating events (possible reasons or causes linked to current problem)", "Select the main events prioritized as 1, 2 and 3 from the lists", "Details of events"
10. Go to the page "Clinical summary"
   Expected: The page shows "Clinical summary"
11. Go to the page "Intervention & follow-up"
   Expected: The page shows "Overall goals for therapy", "Follow-up"

## Test data

```json
{
  "pages": [
    "Consultation",
    "History",
    "Risk factors",
    "Resilience and coping",
    "Problems / symptoms",
    "Scores",
    "Diagnosis",
    "Events",
    "Clinical summary",
    "Intervention & follow-up"
  ]
}
```

