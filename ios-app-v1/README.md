# @ign-var:PROJECT_NAME={current_dir}@

@ign-var:APP_DESCRIPTION=A SwiftUI iOS app@.

This project is a SwiftUI iPhone/iPad app scaffold with:

- SwiftPM modules for app feature code and tests.
- An Xcode iOS app wrapper at `@ign-var:IOS_APP_TARGET=App@.xcodeproj`.
- Simulator build and smoke-test scripts.
- Unsigned and signed iOS archive/export helpers.
- mise-managed Python, Ruby, Fastlane, SwiftLint, and gitleaks tooling.

## Requirements

- macOS 14 or later for local iOS development.
- Xcode with iOS @ign-var:IOS_DEPLOYMENT_TARGET=17.0@ SDK or later.
- Swift @ign-var:SWIFT_TOOLS_VERSION=6.0@ toolchain.
- `mise` for installing developer tools and running repository tasks.
- Optional: `kinko` for injecting user-scoped secrets into individual commands.

## Run Locally

Install the declared developer tools:

```bash
mise install
```

For commands that need secrets, run mise through `kinko exec`; no secret values
belong in this repository or in `mise.toml`.

Build and test the Swift package:

```bash
mise run build
mise run test
```

Build the iPhone/iPad simulator app bundles:

```bash
mise run build:app
```

Launch-smoke the simulator app bundles:

```bash
mise run smoke:simulator-app
```

The Xcode app wrapper is `@ign-var:IOS_APP_TARGET=App@.xcodeproj` with the shared
`@ign-var:IOS_APP_TARGET=App@` scheme.

## Useful Commands

```bash
mise run lint
mise run build
mise run test
mise run build:app
mise run smoke:simulator-app
mise run archive:ios-app
mise run archive:ios-app-signed
mise run export:ios-app
mise run check:ios-ipa
```

Run `mise tasks ls` for the full task surface.

## Package Layout

- `Sources/@ign-var:IOS_APP_TARGET=App@`: SwiftUI app entry point.
- `Sources/@ign-var:IOS_FEATURE_TARGET=AppFeature@`: app feature module, screen models, and reusable views.
- `Tests/@ign-var:IOS_FEATURE_TARGET=AppFeature@Tests`: SwiftPM tests.
- `scripts`: Xcode build, simulator, archive, and export helpers.
- `design-docs`: architecture and implementation notes.
- `impl-plans`: implementation plans.

## Release Policy

This template intentionally does not include macOS release or Homebrew release
tooling. Do not add Homebrew formula/cask packaging, Mac app release scripts, or
Mac distribution artifacts unless the project explicitly changes scope.

iOS App Store/TestFlight export is supported through `mise run archive:ios-app-signed`,
`mise run export:ios-app`, and `mise run check:ios-ipa` after Apple signing is configured.

## App Store and TestFlight Releases

The generated project includes reusable agent skills under `.agents/skills/`:

- `ios-testflight-release`: signed archive, IPA validation, App Store Connect
  processing, and TestFlight distribution workflow.
- `ios-app-store-release`: production metadata, privacy, pricing, submission,
  and live-state workflow.
- `ios-product-screenshots`: controlled iPhone/iPad storefront screenshot
  capture and review workflow.

Run `mise run check:ios-ipa` after export and before uploading the IPA through Xcode
Organizer, Transporter, or approved App Store Connect automation. Uploading is
not evidence that Apple has processed the build or distributed it to testers.
