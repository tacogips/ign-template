---
name: ios-app-store-release
description: Prepare, submit, monitor, and diagnose generic iOS/iPadOS production releases through App Store Connect, including metadata, screenshots, privacy, pricing, availability, review, and release-state verification.
---

# iOS App Store Release

Use this skill for the production stage after the TestFlight pipeline. Read and use `../ios-testflight-release/SKILL.md` for archive, IPA validation, upload, and build processing. Read `../ios-product-screenshots/SKILL.md` when storefront screenshots change.

## Lock the owner decisions

Before changing App Store Connect or submitting for review, obtain explicit decisions for the base price (or Free), countries/regions, manual/automatic/scheduled release, review contact details, sign-in/demo access, and whether ads or analytics are included. Do not infer personal data, price, territories, or release timing.

## Prepare a traceable candidate

1. Preserve unrelated worktree changes and confirm the marketing version, build number, bundle identifier, privacy manifest, and release notes represent the intended binary.
2. Complete the TestFlight workflow and attach the exact processed build in App Store Connect.
3. Commit and push the intended release changes through the repository’s normal workflow. When the project uses release tags, create an annotated `<marketing-version>.<build-number>` tag only after verifying it resolves to the pushed release commit. Never move a published tag.

## Complete App Store Connect gates

Verify the current App Store Connect UI and official Apple documentation before changing declarations; forms and requirements evolve. Complete and verify:

- localized name, subtitle, description, keywords, URLs, copyright, category, and screenshots;
- content rights, age rating, and encryption/export-compliance declarations;
- a reachable privacy-policy URL and App Privacy answers based on the exact binary and all third-party SDK behavior;
- price schedule, availability, review contact information, review notes, and sign-in instructions where needed;
- the intended release mode and the exact processed build.

Re-derive privacy disclosures whenever SDKs, advertising, analytics, data collection, or data sharing changes. Do not reuse an ad-free disclosure for an advertising-enabled build.

## Submit and verify

Use App Store Connect UI automation only when the user has authorized the external action. Obtain an action-time confirmation before final submission when the controlling UI policy requires it. A successful submission is not proof review began or the app was released.

Record the exact version/build and live state, interpreting them strictly:

- `WAITING_FOR_REVIEW`: accepted and queued;
- `IN_REVIEW`: Apple review has started;
- `PENDING_DEVELOPER_RELEASE`: approved and awaiting manual release;
- `READY_FOR_DISTRIBUTION`: approved and released.

Never claim approval or public availability without the corresponding live App Store Connect state. Keep only non-secret evidence in the repository.
