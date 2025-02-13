# TRANSLATIONS 🏴󠁧󠁢󠁥󠁮󠁧󠁿🇮🇶

## Overview
OpenMRS is used in many countries around the world, and it is important that the software is available in the local language. Translations are handled on 2 sides; the backend and the frontend. The backend translations are facilitated by the Concept Dictionary that uses Open Concept Lab (OCL) for metadata management. While on the frontend, it's a mixture of frontend libraries like i18next and [Transifex](https://www.transifex.com/) platform for easier translation management and review. If you would like to help translate OpenMRS into your language, please visit the [OpenMRS project on Transifex](https://app.transifex.com/openmrs/openmrs3).

## Translating OpenMRS

### Getting Started

To change the language,

1. Login to the app http://lime-mosul-dev.madiro.org/openmrs/spa/login After login you will be redirected to the home page.
2. Navigate and click on the profile icon on the top right corner, there you will see an option to Change language. This will open a list of languages available for translation.
3. Select the language you want to translate to and confirm the change. The page will reload and the language will be changed.

### Managing Concept Metadata Translations

Concepts are the building blocks of the OpenMRS data model. They are used to represent clinical data in a structured way. Concepts are stored in the Concept Dictionary and can be translated into multiple languages. The Concept Dictionary uses Open Concept Lab (OCL) for metadata management. To translate concepts, you need to have an account on OCL. You can sign up for an account on the [OCL website](https://openconceptlab.org/). Once you have an account, you can log in to OCL and start translating concepts.

These concepts can then be added to your distro and used in forms, reports, and other parts of the OpenMRS application.

![Concept Dictionary](https://user-images.githubusercontent.com/29705179/134760073-3b3b3b3b-1b3b-4b3b-8b3b-3b3b3b3b3b3b.png)


### Translating Forms

Forms are used to collect data from patients. Forms are made up of pages, sections, questions and answers.

You can translate forms using the Form translation files. These files are JSON files that contain the translations for the form element labels. To translate a form, you need to create a translation file and append it with the short hand of the language you want to translate to for example `F13-PNC_translations_ar.json` for Arabic translations. The translation files are stored in the `ampathformtranslations` directory of your distribution.

You can also use the Concept Dictionary to automatically translate answer labels.

We will be using this form as a reference for the translation examples below.

> F13-PNC.json

```json
{
  "name": "F13-PNC",
  "description": "Postnatal Care Form",
  "version": "1",
  "published": true,
  "uuid": "",
  "processor": "EncounterFormProcessor",
  "encounter": "Maternal Health",
  "encounterType": "dd528487-82a5-4082-9c72-ed246bd49591",
  "retired": false,
  "referencedForms": [],
  "pages": [
    {
      "label": "Postnatal Care",
      "sections": [
        {
          "label": "General information",
          "isExpanded": false,
          "questions": [
            {
              "id": "typeOfConsultation",
              "label": "Type of consultation",
              "type": "obs",
              "required": false,
              "questionOptions": {
                "rendering": "radio",
                "concept": "typeOfConsultation",
                "answers": [
                  {
                    "label": "Admission",
                    "concept": "admission"
                  },
                  {
                    "label": "Follow up",
                    "concept": "followUp"
                  },
                  {
                    "label": "Discharge",
                    "concept": "discharge"
                  }
                ]
              }
            },
            {
              "id": "caretakersName",
              "label": "Caretaker's name",
              "type": "obs",
              "required": false,
              "questionOptions": {
                "rendering": "text",
                "concept": "caretakersName"
              }
            }
          ]
        }
      ]
    }
  ]
}
```

#### 1. Pages, Sections, and Questions

Pages, sections, and questions use the translation file for translation of labels. The translation JSON file has the same name as the form JSON with the language specified using the short name. The keys within this file correspond to the labels of the pages, sections, and questions in the form JSON.

To translate the F13-PNC form to Arabic, you would create a file named `F13-PNC_translations_ar.json` and add the translations for the labels in the form JSON.

> F13-PNC_translations_ar.json

```json
{
  "uuid": "",
  "form": "F13-PNC",
  "description": "Ar Translations for 'F13-PNC'",
  "language": "ar",
  "translations": {
    "Postnatal Care": "رعاية ما بعد الولادة",
    "General information": "معلومات عامة",
    "Type of consultation": "نوع الاستشارة",
    "Admission": "القبول",
    "Follow up": "متابعة",
    "Discharge": "الخروج",
    "Caretaker's name": "اسم الراعي"
  }
}
```

sample_form.json

```json
{
  "name": "Sample form",
  "description": "MSF Form - Sample form",
  "version": "1",
  "published": true,
  "uuid": "",
  "processor": "EncounterFormProcessor",
  "encounter": "Consultation",
  "encounterType": "dd528487-82a5-4082-9c72-ed246bd49591",
  "retired": false,
  "referencedForms": [],
  "pages": [
    {
      "label": "Test Page",
      "sections": [
        {
          "label": "General information",
          "isExpanded": false,
          "questions": [
            {
              "id": "typeOfConsultation",
              "label": "Type of consultation",
              "type": "obs",
              "required": false,
              "questionOptions": {
                "rendering": "radio",
                "concept": "typeOfConsultation",
                "answers": [
                  {
                    "label": "Admission",
                    "concept": "admission"
                  },
                  {
                    "label": "Follow up",
                    "concept": "followUp"
                  },
                  {
                    "label": "Discharge",
                    "concept": "discharge"
                  }
                ]
              }
            },
            {
              "id": "caretakersName",
              "label": "Caretaker's name",
              "type": "obs",
              "required": false,
              "questionOptions": {
                "rendering": "text",
                "concept": "caretakersName"
              }
            }
          ]
        }
      ]
    }
  ]
}

```

sample_form_translations_ar.json

```json
{
  "uuid": "",
  "form": "Sample form",
  "description": "Ar Translations for 'Sample form'",
  "language": "ar",
  "translations": {
    "Test Page": "صفحة الاختبار",
    "General information": "معلومات عامة",
    "Type of consultation": "نوع الاستشارة",
    "Admission": "القبول",
    "Follow up": "متابعة",
    "Discharge": "الخروج",
    "Caretaker's name": "اسم الراعي"
  }
}
```


#### 2. Answers

#### a) Using the Concept dictionary (OCL)

#### b) Using the Form translation files
