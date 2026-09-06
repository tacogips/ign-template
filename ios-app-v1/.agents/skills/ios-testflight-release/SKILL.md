---
name: ios-testflight-release
description: Build, validate, upload, and verify a generic iOS/iPadOS app for TestFlight. Use for signing, App Store Connect upload, build-processing failures, and TestFlight distribution evidence.
---

# iOS TestFlight Release

Ship the exact signed IPA and distinguish each Apple-controlled state. An exported IPA or successful upload is not proof that a build has processed or reached testers.

## Prepare the candidate

1. Read `AGENTS.md`, inspect `git status --short`, and preserve unrelated changes.
2. Confirm the Xcode project has one intended `MARKETING_VERSION`, `CURRENT_PROJECT_VERSION`, `PRODUCT_BUNDLE_IDENTIFIER`, and `TARGETED_DEVICE_FAMILY = "1,2"`.
3. Run the local checks:

   ```bash
   mise run test
   mise run lint
   mise run build:app
   mise run smoke:simulator-app
   mise run archive:ios-app-signed
   mise run export:ios-app
   mise run check:ios-ipa
   ```

4. `mise run archive:ios-app-signed` requires `IOS_APP_APPLE_TEAM_ID` (or `APPLE_TEAM_ID`) and a usable Apple Distribution signing identity. Do not put Apple credentials, team IDs, certificates, provisioning profiles, or private keys in tracked files.

## Upload and process

1. Upload the generated IPA in `.build/xcode-exports/` with Xcode Organizer, Transporter, or approved App Store Connect API automation. Prefer the project’s documented upload command when it exists; do not use deprecated `altool` as the default path.
2. If App Store Connect reports that the build number was previously uploaded, increment `CURRENT_PROJECT_VERSION`, rebuild, export, and upload the new build. A rejected or invisible build number can still be consumed.
3. Wait for the exact marketing version and build number to finish processing in App Store Connect.
4. Add the processed build to the intended TestFlight tester group and verify the build-to-group relationship directly.

`VALID_BINARY`, `VALID`, `BETA_INTERNAL_TESTING`, completed import, and a
successful upload receipt do not prove tester access. They describe upload,
processing, or build eligibility. Treat TestFlight distribution as a separate
relationship that must be checked for the exact marketing version and build.

In App Store Connect, verify that the build detail shows the intended group
instead of `Groups (0)`, then verify that the group page lists the same version
and build. An equivalent App Store Connect API relationship response is
acceptable. After assigning a group, re-read the relationship rather than
assuming the mutation succeeded. Record whether the group has automatic
distribution enabled; when it is disabled, explicitly assign every new build.

## Complete the manual gate

Record non-secret evidence that the exact build was installed and launched from TestFlight on the device families required by the release. For universal apps this normally includes trusted iPhone and iPad hardware. Include version/build, processing state, tester-group distribution, and device-family outcomes; never include tester identities, UDIDs, or credentials.

## Failure diagnosis

- Run `mise run check:ios-ipa` before diagnosing an `ITMS-90207` executable error. If the IPA has a single app, an arm64 executable, the intended bundle identifier, and a valid signature, the remaining problem is likely upload transport, account authorization, or Apple-side validation.
- Treat an App Store Connect upload response as submission only. It may return before build processing completes.
- If testers see an older build even though a newer build processed, inspect the newer build's group relationship first. An unassigned build is not visible to that group.
- Do not claim TestFlight completion until processing, the exact tester-group relationship, and device installation have all been verified.
