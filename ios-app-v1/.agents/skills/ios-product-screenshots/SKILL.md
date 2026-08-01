---
name: ios-product-screenshots
description: Capture, inspect, package, and validate generic iPhone and iPad App Store screenshots from a controlled simulator state.
---

# iOS Product Screenshots

Create storefront imagery from a deterministic, review-only simulator configuration. Do not add sample content, test accounts, debug overlays, consent bypasses, or feature flags to ordinary production launches.

## Prepare

1. Inspect the project’s simulator build and smoke-test commands and identify the supported iPhone and iPad devices and locales.
2. Define a review-only launch configuration that produces representative, privacy-safe data and can be removed from normal launches.
3. Capture the exact screen sizes and localizations currently required by App Store Connect; verify the requirements in Apple’s current documentation before shipping screenshots.

## Capture and review

- Build the app for each target device family and locale, then capture the full device screen with no simulator chrome or desktop background.
- Visually inspect each packaged screenshot for complete safe areas, correct localization, legible content, intended privacy/advertising state, and no debug UI, test credentials, notifications, or unintended overlays.
- Store raw generated captures under ignored build output. Commit only intentional, sanitized, curated image assets.

## Validate

Before upload, confirm all metadata references, screenshot filenames, dimensions, and locale mappings match. Re-capture imagery when the visible UI, localization, privacy behavior, ads, or product claims materially change.

Do not upload screenshots to App Store Connect, deploy web assets, or commit changes unless the user explicitly requests that external action.
