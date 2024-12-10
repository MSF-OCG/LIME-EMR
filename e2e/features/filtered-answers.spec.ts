import { test, expect } from '@playwright/test';
import { timeout } from '../../../playwright.config';

test('test', async ({ page }) => {
    await page.goto('http://lime-mosul-uat.madiro.org/openmrs/spa/patient/0f2851c6-62e1-4d42-932c-e094d621ef6a/chart/Patient%20Summary'); 
    await page.getByRole('button', { name: 'Confirm' }).click();
    await page.getByLabel('النماذج السريرية').click();
    await page.getByText('MSF Mental Health - MHPSS Baseline').click();
});