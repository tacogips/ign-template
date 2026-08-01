# App Store Connect Production Gates

Use this checklist against the current App Store Connect UI and current official Apple documentation.

## Candidate and provenance

- Intended marketing version, build number, and bundle identifier are consistent.
- Signed IPA passes `task check:ios-ipa`.
- The exact build has completed App Store Connect processing and TestFlight validation.
- Intended release changes are committed and pushed; any release tag resolves to that same commit.

## Storefront and compliance

- Each required locale has complete, current metadata and correctly sized screenshots.
- Content rights, age rating, encryption/export compliance, pricing, availability, and review contact are complete.
- Privacy policy URL is reachable.
- App Privacy matches the app, its backends, and every third-party SDK.
- The selected release mode reflects the owner’s decision.

## Submission and live state

- The processed build is attached to the editable version.
- App Review submission has explicit authorization.
- Release evidence records the version, build, submission time, and live Apple state without secrets.
