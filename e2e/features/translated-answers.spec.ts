import test, { expect } from "@playwright/test";

test('translated answers', async ({ page }) => {
  await page.goto('http://lime-mosul-dev.madiro.org/openmrs/spa/patient/ec072374-1d43-4d7f-bc04-26d47a58638d/chart/Patient%20Summary');
  await page.getByLabel('Clinical forms').click();
  await page.getByText('MSF Mental Health - MHPSS Baseline').click();
  await page.locator('label').filter({ hasText: 'Parent-child' }).locator('span').first().click();
  await expect(page.getByText('Parent-child')).toBeVisible();
});
