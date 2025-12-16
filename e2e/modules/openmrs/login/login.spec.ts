import { expect, test } from '@playwright/test';

const openmrsBaseUrl = process.env.OPENMRS_BASE_URL || 'https://lime-mosul-dev.madiro.org/openmrs/spa';
const openmrsLoginUrl = `${openmrsBaseUrl.replace(/\/$/, '')}/login`;
const openmrsHomeUrl = `${openmrsBaseUrl.replace(/\/$/, '')}/home`;
const openmrsUsername = process.env.OPENMRS_USERNAME || 'admin';
const openmrsPassword = process.env.OPENMRS_PASSWORD || 'Admin123';

test('OpenMRS login @login-openmrs', async ({ page }) => {
  await page.goto(openmrsLoginUrl);
  await page.getByLabel('Username').fill(openmrsUsername);
  await page.getByRole('button', { name: 'Continue' }).click();
  await page.locator('input#password').fill(openmrsPassword);
  await page.getByRole('button', { name: 'Log in' }).click();

  const locationPicker = page.getByText('Registration Counter (REG');
  if (await locationPicker.isVisible({ timeout: 3000 }).catch(() => false)) {
    await locationPicker.click();
    await page.getByRole('button', { name: 'Confirm' }).click();
  }

  await page.waitForURL(openmrsHomeUrl);
  await expect(page.locator('section')).toContainText('Home');
});