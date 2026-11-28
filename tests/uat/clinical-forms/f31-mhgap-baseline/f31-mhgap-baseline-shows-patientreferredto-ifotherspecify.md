---
id: f31-mhgap-baseline-shows-patientreferredto-ifotherspecify
title: "F31-mhGAP Baseline: \"If other, specify\" shows only when \"Patient referred to\" is \"Other\""
kind: automated
priority: medium
feature: clinical-forms
form: F31-mhGAP Baseline
workflow: openmrs-clinical-encounters
automated_by: tests/e2e/forms.spec.ts
generator: form
implementations: [matsapha-eswatini]
sources: [distro/configs/openmrs/initializer_config/ampathforms/F31-mhGAP_Baseline_v2.json]
---

# F31-mhGAP Baseline: "If other, specify" shows only when "Patient referred to" is "Other"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F31-mhGAP Baseline"

## Steps

1. Open the form on the page "Follow-up"
2. Answer "Patient referred to" with "Medical care (MSF, MoH, NGO)"
   Expected: "If other, specify" stay hidden
3. Answer "Patient referred to" with "Other"
   Expected: "If other, specify" appear

## Test data

```json
{
  "controller": {
    "id": "patientReferredTo",
    "label": "Patient referred to"
  },
  "show_with": [
    "Other"
  ],
  "hide_with": "Medical care (MSF, MoH, NGO)",
  "shown": [
    {
      "id": "patientReferredTo_ifOtherSpecify",
      "label": "If other, specify"
    }
  ]
}
```

