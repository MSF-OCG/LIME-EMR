import { expect, test } from '@playwright/test';

const openfnBaseUrl = process.env.OPENFN_BASE_URL;
const openfnEmail = process.env.OPENFN_EMAIL;
const openfnPassword = process.env.OPENFN_PASSWORD;

const hasOpenFnConfig = Boolean(openfnBaseUrl && openfnEmail && openfnPassword);

test('OpenFn login @login-openfn', async ({ page }) => {

  // At this point TypeScript still thinks these can be undefined, so we assert.
  if (!openfnBaseUrl || !openfnEmail || !openfnPassword) {
    test.fail(true, 'OpenFn credentials are not configured');
    return;
  }

  // Navigate to the OpenFn login page (base URL already points at OpenFn).
  await page.goto(openfnBaseUrl);

  // Wait explicitly for the login form to be visible.
  await page.waitForSelector('#login form');

  // Fill in the login form using the exact attributes from the HTML.
  await page.locator('input[name="user[email]"]').fill(openfnEmail);
  await page.locator('input[name="user[password]"]').fill(openfnPassword);

  // Click the "Log in" submit button.
  await page.locator('#login button[type="submit"]').click();

  await page.waitForLoadState('networkidle');

  // Basic assertion: the login button should no longer be visible (we're logged in).
  await expect(page.getByRole('button', { name: /(log in|sign in)/i })).not.toBeVisible();
});
