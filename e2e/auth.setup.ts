import { test as setup, expect } from '@playwright/test';
import path from 'path';

const authFile = path.join(__dirname, '../playwright/.auth/user.json');

setup('authenticate uat', async ({ page }) => {
  // Perform authentication steps. Replace these actions with your own.
  await page.goto('http://lime-mosul-uat.madiro.org/openmrs/spa/login');
  await page.getByLabel('Username').fill('tester');
  await page.getByRole('button', { name: 'Continue' }).click();
  await page.getByLabel('Password').fill('Tester123!');
  await page.getByRole('button', { name: 'Log in' }).click();
  await page.getByText('Registration Counter (REG').click();
  await page.getByRole('button', { name: 'Confirm' }).click();
  // Wait until the page receives the cookies.
  //
  // Sometimes login flow sets cookies in the process of several redirects.
  // Wait for the final URL to ensure that the cookies are actually set.
  await page.waitForURL('http://lime-mosul-uat.madiro.org/openmrs/spa/home');
  // Alternatively, you can wait until the page reaches a state where all cookies are set.
  await expect(page.locator('section')).toContainText('Home');

  // End of authentication steps.

  await page.context().storageState({ path: authFile });
});

setup('authenticate dev', async ({ page }) => {
  // Perform authentication steps. Replace these actions with your own.
  await page.goto('http://lime-mosul-dev.madiro.org/openmrs/spa/login');
  await page.getByLabel('Username').fill('admin');
  await page.getByRole('button', { name: 'Continue' }).click();
  await page.getByLabel('Password').fill('Admin123');
  await page.getByRole('button', { name: 'Log in' }).click();
  // await page.getByText('Mental Health (MH').click();
  // await page.getByRole('button', { name: 'Confirm' }).click();
  // Wait until the page receives the cookies.
  //
  // Sometimes login flow sets cookies in the process of several redirects.
  // Wait for the final URL to ensure that the cookies are actually set.
  await page.waitForURL('http://lime-mosul-dev.madiro.org/openmrs/spa/home');
  // Alternatively, you can wait until the page reaches a state where all cookies are set.
  await expect(page.locator('section')).toContainText('Home');

  // End of authentication steps.

  await page.context().storageState({ path: authFile });
});
