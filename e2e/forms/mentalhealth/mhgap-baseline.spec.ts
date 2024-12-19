import { expect, test } from '@playwright/test';

test('mhgap baseline form', async ({ page }) => {
  await page.goto(
    'http://lime-mosul-dev.madiro.org/openmrs/spa/patient/ec072374-1d43-4d7f-bc04-26d47a58638d/chart/Patient%20Summary'
  );
  if (page.getByLabel('Start a visit')) {
    await page.getByLabel('Start a visit').click();
    await page.getByText('OPD Visit').click();
    await page.getByRole('button', { name: 'Start visit' }).click();
  } else {
    await page.getByLabel('Clinical forms').click();
    await page.getByText('MSF Mental Health - mhGAP Baseline').click();

    // await page.getByRole('button', { name: 'Save' }).click();
    // await expect(page.getByText('Form submitted successfully')).toBeVisible();
  }
});
