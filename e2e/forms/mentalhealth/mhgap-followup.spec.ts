import { expect, test } from '@playwright/test';

test('mhGap follow-up form', async ({ page }) => {
  await page.goto(
    'http://lime-mosul-dev.madiro.org/openmrs/spa/patient/ec072374-1d43-4d7f-bc04-26d47a58638d/chart/Patient%20Summary'
  );
  if (page.getByLabel('Start a visit')) {
    await page.getByLabel('Start a visit').click();
    await page.getByText('OPD Visit').click();
    await page.getByRole('button', { name: 'Start visit' }).click();
  } else {
    await page.getByLabel('Clinical forms').click();
    await page.getByText('MSF Mental Health - mhGAP Follow-up').click();
    await page.getByLabel('Session number').click();
    await page.getByLabel('Session number').fill('1');
    await page.getByRole('group', { name: 'The patient did not come' }).locator('span').nth(3).click();
    await page.getByLabel('Evolution of symptomsCurrent').click();
    await page.getByLabel('Evolution of symptomsCurrent').fill('Progressive');
    await page.getByLabel('Side effects from current').click();
    await page.getByLabel('Side effects from current').fill('None');
    await page.getByLabel('Basic mental status').click();
    await page.getByLabel('Basic mental status').fill('PTSD');
    await page.getByRole('combobox', { name: 'Clinical diagnosis (only to' }).click();
    await page.getByText('Acute stress reaction').click();
    await page.locator('[id="accordion-item-\\:r2u\\:"] > .-esm-form-engine__page-renderer__formSection___NMgiH > .-esm-form-engine__section-renderer__section___m5psJ > div > div > .cds--fieldset > .cds--form-item > .cds--radio-button-group > div:nth-child(2) > .cds--radio-button__label > .cds--radio-button__appearance').first().click();
    await page.locator('div:nth-child(2) > div > .cds--fieldset > .cds--form-item > .cds--radio-button-group > div:nth-child(2) > .cds--radio-button__label > .cds--radio-button__appearance').click();
    await page.locator('div:nth-child(3) > div > .cds--fieldset > .cds--form-item > .cds--radio-button-group > div:nth-child(2) > .cds--radio-button__label > .cds--radio-button__appearance').first().click();
    await page.locator('div:nth-child(4) > div > .cds--fieldset > .cds--form-item > .cds--radio-button-group > div:nth-child(2) > .cds--radio-button__label > .cds--radio-button__appearance').click();
    await page.locator('div:nth-child(5) > div > .cds--fieldset > .cds--form-item > .cds--radio-button-group > div:nth-child(3) > .cds--radio-button__label > .cds--radio-button__appearance').click();
    await page.locator('div:nth-child(6) > div > .cds--fieldset > .cds--form-item > .cds--radio-button-group > div:nth-child(3) > .cds--radio-button__label > .cds--radio-button__appearance').click();
    await page.locator('div:nth-child(7) > div > .cds--fieldset > .cds--form-item > .cds--radio-button-group > div:nth-child(3) > .cds--radio-button__label > .cds--radio-button__appearance').click();
    await page.locator('div:nth-child(8) > div > .cds--fieldset > .cds--form-item > .cds--radio-button-group > div:nth-child(2) > .cds--radio-button__label > .cds--radio-button__label-text').click();
    await page.locator('div:nth-child(9) > div > .cds--fieldset > .cds--form-item > .cds--radio-button-group > div:nth-child(4) > .cds--radio-button__label > .cds--radio-button__label-text').click();
    await page.locator('label').filter({ hasText: /^Somewhat difficult$/ }).locator('span').first().click();
    await page.getByRole('combobox', { name: 'Depression severity scale' }).click();
    await page.getByText('Minor to mild depression (or').click();
    await page.locator('label').filter({ hasText: '- Mildly ill' }).locator('span').first().click();
    await page.locator('label').filter({ hasText: '- Much improved' }).locator('span').first().click();
    await page.getByLabel('Additional information/notes').click();
    await page.getByLabel('Additional information/notes').fill('Needs further observation');
    await page.getByRole('group', { name: 'Is the patient taking the' }).locator('span').nth(1).click();
    await page.getByLabel('Details if needed').click();
    await page.getByLabel('Details if needed').fill('Monitoring');
    await page.getByRole('group', { name: 'Follow up session required? (' }).locator('span').nth(3).click();
    await page.getByRole('button', { name: 'Save' }).click();
    await expect(page.getByText('Form submitted successfully')).toBeVisible();
  }
});
