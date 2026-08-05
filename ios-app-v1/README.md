# @ign-var:PROJECT_NAME={current_dir}@

@ign-var:APP_DESCRIPTION=A SwiftUI iOS app@.

This project is a SwiftUI iPhone/iPad app scaffold with:

- SwiftPM modules for app feature code and tests.
- An Xcode iOS app wrapper at `@ign-var:IOS_APP_TARGET=App@.xcodeproj`.
- Simulator build and smoke-test scripts.
- Unsigned and signed iOS archive/export helpers.
- Nix, direnv, go-task, SwiftLint, and gitleaks development tooling.
- A pinned Nix dependency graph in `flake.lock` for reproducible shells.

## Requirements

- macOS 14 or later for local iOS development.
- Xcode with iOS @ign-var:IOS_DEPLOYMENT_TARGET=17.0@ SDK or later.
- Swift @ign-var:SWIFT_TOOLS_VERSION=6.0@ toolchain.
- `go-task` for repository task commands.
- Optional: Nix flakes plus direnv for the project development shell.
- Optional: `kinko` for exporting user-scoped secrets into direnv.

## Run Locally

Enter the development shell when using Nix:

```bash
nix develop
```

The checked-in `flake.lock` pins the Nix inputs. When `kinko` is installed,
`.envrc` also exports secrets from the current user's vault; no secret values
belong in this repository.

Build and test the Swift package:

```bash
task build
task test
```

Build the iPhone/iPad simulator app bundles:

```bash
task build:app
```

Launch-smoke the simulator app bundles:

```bash
task smoke:simulator-app
```

The Xcode app wrapper is `@ign-var:IOS_APP_TARGET=App@.xcodeproj` with the shared
`@ign-var:IOS_APP_TARGET=App@` scheme.

## Useful Commands

```bash
task lint
task build
task test
task build:app
task smoke:simulator-app
task archive:ios-app
task archive:ios-app-signed
task export:ios-app
task check:ios-ipa
```

Run `task --list` for the full task surface.

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

iOS App Store/TestFlight export is supported through `task archive:ios-app-signed`,
`task export:ios-app`, and `task check:ios-ipa` after Apple signing is configured.

## App Store and TestFlight Releases

The generated project includes reusable agent skills under `.agents/skills/`:

- `ios-testflight-release`: signed archive, IPA validation, App Store Connect
  processing, and TestFlight distribution workflow.
- `ios-app-store-release`: production metadata, privacy, pricing, submission,
  and live-state workflow.
- `ios-product-screenshots`: controlled iPhone/iPad storefront screenshot
  capture and review workflow.

Run `task check:ios-ipa` after export and before uploading the IPA through Xcode
Organizer, Transporter, or approved App Store Connect automation. Uploading is
not evidence that Apple has processed the build or distributed it to testers.
