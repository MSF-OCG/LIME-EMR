# LIME CHANGE LOG 🚀

## Release 11th July, 2025

### Features & Improvements

- MH - partial display of tooltip - [LIME2-463](https://msf-ocg.atlassian.net/browse/LIME2-463)
- Move away patient stickers from banner esm to patient sticker esm for product release in June - [LIME2-726](https://msf-ocg.atlassian.net/browse/LIME2-726)

- Update Ozone to Alpha 13 - [LIME2-664](https://msf-ocg.atlassian.net/browse/LIME2-664)
- Update to OpenMRS 2.7 - [LIME2-668](https://msf-ocg.atlassian.net/browse/LIME2-668)
- Unable to login after openMRS version upgrade from 2.6 to 2.7 - [LIME2-775](https://msf-ocg.atlassian.net/browse/LIME2-775)
- Laboratory - LabSets added - [LIME2-746](https://msf-ocg.atlassian.net/browse/LIME2-746)
- Resolve shorten OMRS IDs in DHIS2 - List of patient IDs + UUIDs - [LIME2-773](https://msf-ocg.atlassian.net/browse/LIME2-773)
- Import list of MSF diagnosis in Conditions workspace - [LIME2-671](https://msf-ocg.atlassian.net/browse/LIME2-671)

### Bug Fixes

- Extra characters in patient age / date of birth on patient dashboard - [LIME2-783](https://msf-ocg.atlassian.net/browse/LIME2-783)
- FormGen - error on rendering preview - [LIME2-787](https://msf-ocg.atlassian.net/browse/LIME2-787)
- Concepts are not being updated by initializer - [LIME2-781](https://msf-ocg.atlassian.net/browse/LIME2-781)
- ITFC discharge - not able to save - [LIME2-728](https://msf-ocg.atlassian.net/browse/LIME2-728)
- Verify all labtests in the MSF - [LIME2-754](https://msf-ocg.atlassian.net/browse/LIME2-754)
- Fix infinite recursive rendering of `creator` property for the concept's datatype when opening the lab results form - [LIME2-786](https://msf-ocg.atlassian.net/browse/LIME2-786)
- More improvements to duplicated visits issue with the patient search- [LIME2-766](https://msf-ocg.atlassian.net/browse/LIME2-766)
- Fix issue when adding lab results to tests - [LIME2-770](https://msf-ocg.atlassian.net/browse/LIME2-770)

### House Keeping

- Investigate: Move Complex_obs in separated volume + Restic backup (Ozone 13 upgrades) - [LIME2-767](https://msf-ocg.atlassian.net/browse/LIME2-767)
- Investigate: Lab - allow corrections - [LIME2-763](https://msf-ocg.atlassian.net/browse/LIME2-763)
- Investigate: Workspaces - mandatory fields optional - [LIME2-764](https://msf-ocg.atlassian.net/browse/LIME2-764)
- Investigate: All forms - changes not allowed after 24h - [LIME2-762](https://msf-ocg.atlassian.net/browse/LIME2-762)
- Investigate some tests not showing enter results in labs - [LIME2-725](https://msf-ocg.atlassian.net/browse/LIME2-725)

### Experimental

- Fix LIME-EMR CI workflow - [LIME2-790](https://msf-ocg.atlassian.net/browse/LIME2-790)
- Try Ozone Bundled Docker for UAT/Prod - [LIME2-666](https://msf-ocg.atlassian.net/browse/LIME2-666)
- Medication - Import OCG Medical Standard List - [LIME2-298](https://msf-ocg.atlassian.net/browse/LIME2-298)
- Laboratory - corrections applied to OCL - [LIME2-788](https://msf-ocg.atlassian.net/browse/LIME2-788)

## Release 26th June, 2025

### Features & Improvements

- Feeding form - change symbol to represent intake - [LIME2-730](https://msf-ocg.atlassian.net/browse/LIME2-730)
- Update Ozone to Alpha 13 - [LIME2-664](https://msf-ocg.atlassian.net/browse/LIME2-664)
- Fix minified react error in Nutrition feeding form - [LIME2-779](https://msf-ocg.atlassian.net/browse/LIME2-779)
- Family planning - messages appearing according to contra-indication - [LIME2-586](https://msf-ocg.atlassian.net/browse/LIME2-586)
- Laboratory - LabSets added - [LIME2-746](https://msf-ocg.atlassian.net/browse/LIME2-746)
- Create roles with different accesses for nutrition team - [LIME2-623](https://msf-ocg.atlassian.net/browse/LIME2-623)
- Allow for multiple prescriptions in nutrition feeding monitoring form - [LIME2-707](https://msf-ocg.atlassian.net/browse/LIME2-707)
- Add support for order, multiple conditions, unique questionID with prefix, and decimal to FormGen - [LIME2-774](https://msf-ocg.atlassian.net/browse/LIME2-774)
- Verify all labtests in the MSF - [LIME2-754](https://msf-ocg.atlassian.net/browse/LIME2-754)

### Bug Fixes

- Fix environment variable for running OpenMRS on 4001 - [LIME2-780](https://msf-ocg.atlassian.net/browse/LIME2-780)
- Duplicated visits - [LIME2-766](https://msf-ocg.atlassian.net/browse/LIME2-766)
- Some drug orders will not save - ?problem with prefilled units - [LIME2-769](https://msf-ocg.atlassian.net/browse/LIME2-769)
- Medication - Import OCG Medical Standard List - [LIME2-298](https://msf-ocg.atlassian.net/browse/LIME2-298)

### Investigations

- Investigate: All forms - changes not allowed after 24h - [LIME2-762](https://msf-ocg.atlassian.net/browse/LIME2-762)
- Investigate: Workspaces - mandatory fields optional - [LIME2-764](https://msf-ocg.atlassian.net/browse/LIME2-764)
- Investigate: Lab - allow corrections - [LIME2-763](https://msf-ocg.atlassian.net/browse/LIME2-763)

## Release 30th May, 2025

### Features & Improvements

- Appointments list - Add MH providers' initials in type of services [LIME2-761](https://msf-ocg.atlassian.net/browse/LIME2-761)
- Medication - Import OCG Medical Standard List - [LIME2-298](https://msf-ocg.atlassian.net/browse/LIME2-298)

### Bug Fixes

- Add `questionInfo`/ tooltip translations to the translation files in Form Gen - [LIME2-654](https://msf-ocg.atlassian.net/browse/LIME2-654)
- ITFC forms (Admission) - not possible to save - [LIME2-722](https://msf-ocg.atlassian.net/browse/LIME2-722)
- test and meds are not showing in visits module of the correct visit, but a previous visit - [LIME2-742](https://msf-ocg.atlassian.net/browse/LIME2-742)
- PNC - skip logic for Head circumference not working - [LIME2-735](https://msf-ocg.atlassian.net/browse/LIME2-735)
- Family planning - tooltip not working - [LIME2-737](https://msf-ocg.atlassian.net/browse/LIME2-737)
- PNC - PHQ2 tooltip not appearing - [LIME2-734](https://msf-ocg.atlassian.net/browse/LIME2-734)
- PNC - skip logic for Problems not working - [LIME2-732](https://msf-ocg.atlassian.net/browse/LIME2-732)
- PNC - tooltip added to Infant 1 section - [LIME2-641](https://msf-ocg.atlassian.net/browse/LIME2-641)
- PNC - Anaemia question not appearing - [LIME2-733](https://msf-ocg.atlassian.net/browse/LIME2-733)
- PNC - Referral reason question skip logic not working - [LIME2-736](https://msf-ocg.atlassian.net/browse/LIME2-736)
- Duplicated visits - [LIME2-766](https://msf-ocg.atlassian.net/browse/LIME2-766)

### Patient Stickers

- Implementors should conditionally pass custom xsl file to customize pdf look and feel - [LIME2-752](https://msf-ocg.atlassian.net/browse/LIME2-752)
- Patient Identifier Sticker report referencing a null Report Definition (all reports in the common reports module) - [LIME2-749](https://msf-ocg.atlassian.net/browse/LIME2-749)
- SqlFileDataSetDefinition Restricts Access to Essential Patient Data Values - [LIME2-751](https://msf-ocg.atlassian.net/browse/LIME2-751)
- Move Patient Identifier Sticker Report backend logic to a new backend Module - [LIME2-743](https://msf-ocg.atlassian.net/browse/LIME2-743)
- Fix Arabic disjointed letters on stickers - [LIME2-753](https://msf-ocg.atlassian.net/browse/LIME2-753)
- Enhance Age Display to Show Years/Months or Weeks/Days Instead of Just 0 - [LIME2-756](https://msf-ocg.atlassian.net/browse/LIME2-756)

## Release 16th May, 2025

### Features & Improvements

- Re-enable laboratory and configs in LIME-EMR - [LIME2-703](https://msf-ocg.atlassian.net/browse/LIME2-703)
- Add missing translations to workspace buttons - [LIME2-690](https://msf-ocg.atlassian.net/browse/LIME2-690)

### Bug Fixes

- ITFC discharge - skip logic not working - [LIME2-729](https://msf-ocg.atlassian.net/browse/LIME2-729)
- Immunization - not possible to save - [LIME2-727](https://msf-ocg.atlassian.net/browse/LIME2-727)
- Notes are not displaying in the note tab of visits [LIME2-741](https://msf-ocg.atlassian.net/browse/LIME2-741)
- Cannot create patient with "unknown" name in registration - [LIME2-738](https://msf-ocg.atlassian.net/browse/LIME2-738)
- Patient name fix in laboratory (Community)
- ITFC discharge - skip logic for vaccination questions not working - [LIME2-706](https://msf-ocg.atlassian.net/browse/LIME2-706)
- ITFC discharge form - Get admission date/time from ITFC admission form - [LIME2-385](https://msf-ocg.atlassian.net/browse/LIME2-385)
- ITFC discharge - skip logic for vaccination questions not working - [LIME2-706](https://msf-ocg.atlassian.net/browse/LIME2-706)
- Remove one of the C-Reactive Test from the lab order list - [LIME2-713](https://msf-ocg.atlassian.net/browse/LIME2-713)
- Registration - error on recording age in months - [LIME2-460](https://msf-ocg.atlassian.net/browse/LIME2-460)

### Patient Stickers

- Add DHIS2 IDs on stickers - [LIME2-740](https://msf-ocg.atlassian.net/browse/LIME2-740)
- Patient ID not fully visible in patient banner - [LIME2-739](https://msf-ocg.atlassian.net/browse/LIME2-739)
- Add Arabic translations to patient sticker - [LIME2-710](https://msf-ocg.atlassian.net/browse/LIME2-710)
- Adjust created Sticker report layout to match v1 - [LIME2-709](https://msf-ocg.atlassian.net/browse/LIME2-709)
- Use Patient ID sticker report API in frontend - [LIME2-708](https://msf-ocg.atlassian.net/browse/LIME2-708)

### Go-LIVE DB Preparation

- Test prod users SQL + script on local - [LIME2-720](https://msf-ocg.atlassian.net/browse/LIME2-720)
- Add permissions, roles and users for laboratory technician, nutrition clinician and nutrition assistant nurse - [LIME2-661](https://msf-ocg.atlassian.net/browse/LIME2-661)
