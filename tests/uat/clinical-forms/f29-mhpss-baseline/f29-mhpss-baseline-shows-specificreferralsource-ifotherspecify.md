---
id: f29-mhpss-baseline-shows-specificreferralsource-ifotherspecify
title: "F29-MHPSS Baseline: \"If other, specify\" shows only when \"Specific referral source\" is \"Other\""
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

# F29-MHPSS Baseline: "If other, specify" shows only when "Specific referral source" is "Other"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F29-MHPSS Baseline"

## Steps

1. Open the form on the page "Consultation"
2. Answer "Specific referral source" with "IPD"
   Expected: "If other, specify" stay hidden
3. Answer "Specific referral source" with "Other"
   Expected: "If other, specify" appear

## Test data

```json
{
  "controller": {
    "id": "specificReferralSource",
    "label": "Specific referral source"
  },
  "show_with": [
    "Other"
  ],
  "hide_with": "IPD",
  "shown": [
    {
      "id": "specificReferralSource_ifOtherSpecify",
      "label": "If other, specify"
    }
  ]
}
```

