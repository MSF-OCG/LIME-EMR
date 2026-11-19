---
id: f29-mhpss-baseline-shows-totalnumberofbeneficiariesinfamilyconsultation
title: "F29-MHPSS Baseline: \"Total number of beneficiaries in family consultation\" shows only when \"Type of consultation\" is \"Family\""
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

# F29-MHPSS Baseline: "Total number of beneficiaries in family consultation" shows only when "Type of consultation" is "Family"

## Preconditions

- A test patient with an active visit
- Signed in as a user who can fill "F29-MHPSS Baseline"

## Steps

1. Open the form on the page "Consultation"
2. Answer "Type of consultation" with "Individual"
   Expected: "Total number of beneficiaries in family consultation" stay hidden
3. Answer "Type of consultation" with "Family"
   Expected: "Total number of beneficiaries in family consultation" appear

## Test data

```json
{
  "controller": {
    "id": "typeOfConsultation",
    "label": "Type of consultation"
  },
  "show_with": [
    "Family"
  ],
  "hide_with": "Individual",
  "shown": [
    {
      "id": "totalNumberOfBeneficiariesInFamilyConsultation",
      "label": "Total number of beneficiaries in family consultation"
    }
  ]
}
```

