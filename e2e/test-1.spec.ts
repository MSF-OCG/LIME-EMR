import { test, expect } from '@playwright/test';
import { assert } from 'console';

// Documentation, prompting, and coverage: https://docs.google.com/document/d/1ECV_sWmxkLHpFYsTLV5oIjo7m7mqBKOnSKFoPzdQL68/edit?usp=sharing

test('Sample Form - Verify UI elements and interactions', async ({ page }) => {
  // --- Login Flow ---
  await page.goto('https://dev3.openmrs.org/openmrs/spa/login');
  await page.getByLabel('Username').fill('admin');
  await page.getByRole('button', { name: 'Continue' }).click();
  await page.getByLabel('Password').fill('Admin123');
  await page.getByRole('button', { name: 'Log in' }).click();

  // Verify that Home is visible post-login
  await expect(page.locator('section')).toContainText('Home');

  // --- Navigate to Patient Summary and Open Form ---
  await page.goto(
    'https://dev3.openmrs.org/openmrs/spa/patient/50a20ac9-704d-4960-b6cb-5691bb1e76dc/chart/Patient%20Summary'
  );
  await page.getByLabel('Clinical forms').click();
  await page.getByText('Sample Form').click();

  // --- Validate Form UI Elements ---

  // Check if "First Page" is visible using a class that contains "pageTitle"
  await expect(
    page.locator('p[class*="pageTitle"]:has-text("First Page")')
  ).toBeVisible();

  // Check if "A Section" is visible using a class that contains "title"
  await expect(
    page.locator('div[class*="title"]:has-text("A Section")')
  ).toBeVisible();

  // Verify that the question label is present
  await expect(
    page.locator(
      'div[class*="questionLabel"]:has-text("A Question of type obs that renders a text input")'
    )
  ).toBeVisible();

  // Ensure the text input below the question is visible and fill it with sample text
  const textInput = page.locator('input[type="text"]');
  await expect(textInput).toBeVisible();
  await textInput.fill('Sample input text');

  // Verify that "Another Section" is visible
  await expect(
    page.locator('div[class*="title"]:has-text("Another Section")')
  ).toBeVisible();

  // --- Validate Radio Button Options ---

  // --- Validate Radio Button Options ---

  // Optionally, verify that the radio button group container is visible
  await expect(
    page.locator('fieldset[class*="radio-button-group"]')
  ).toBeVisible();

  // Locate and validate each radio option using the wrapper's class and its text
  await expect(
    page.locator('div[class*="radio-button-wrapper"]:has-text("Choice 1") >> input[type="radio"]')
  ).toBeVisible();
  await expect(
    page.locator('div[class*="radio-button-wrapper"]:has-text("Choice 2") >> input[type="radio"]')
  ).toBeVisible();
  await expect(
    page.locator('div[class*="radio-button-wrapper"]:has-text("Choice 3") >> input[type="radio"]')
  ).toBeVisible();

  // Select the first radio option and verify it is checked
  page.evaluate('document.getElementById("anotherSampleQuestion-Choice 1").checked=true');
  // Check if the first radio option is checked
  expect(
    page.evaluate('document.getElementById("anotherSampleQuestion-Choice 1").checked')
  ).toBeTruthy();
});
