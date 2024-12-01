import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('http://lime-mosul-uat.madiro.org/openmrs/spa/login');
  await page.getByLabel('Username').fill('tester');
  await page.getByRole('button', { name: 'Continue' }).click();
  await page.getByLabel('Password').fill('Tester123!');
  await page.getByRole('button', { name: 'Log in' }).click();
  await page.getByText('Registration Counter (REG').click();
  await page.getByRole('button', { name: 'Confirm' }).click();
  await expect(page.locator('section')).toContainText('Home');
});