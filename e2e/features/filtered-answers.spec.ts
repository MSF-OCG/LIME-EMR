import { test, expect } from '@playwright/test';
import { timeout } from '../../../playwright.config';

test('test', async ({ page }) => {
    await page.goto('http://lime-mosul-uat.madiro.org/openmrs/spa/patient/4aa1d485-5904-4b17-8bed-3affd38e95e7/chart/Patient%20Summary'); 
    
});