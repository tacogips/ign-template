# AGENTS.md

## Language

Always think and respond in English, regardless of the user's language.
Do not use emojis.

## Project Overview

This is a SwiftUI iOS app project generated from the `ios-app-v1` ign template.
It uses SwiftPM for modular app code and an Xcode project wrapper for iPhone/iPad
builds, simulator checks, archives, and App Store/TestFlight export.

## Development Environment

- Language: Swift
- UI framework: SwiftUI
- Package manager: Swift Package Manager
- App project: Xcode iOS app target
- Build runner: go-task
- Environment manager: Nix flakes and direnv

## Commands

```bash
task build
task test
task build:app
task smoke:simulator-app
task archive:ios-app
task archive:ios-app-signed
task export:ios-app
task lint
```

## Coding Standards

- Follow standard Swift conventions and idioms.
- Use Swift concurrency deliberately; keep UI state on the main actor.
- Keep app feature code in `Sources/@ign-var:IOS_FEATURE_TARGET=AppFeature@`.
- Keep the SwiftUI app entry point in `Sources/@ign-var:IOS_APP_TARGET=App@`.
- Add focused tests under `Tests/@ign-var:IOS_FEATURE_TARGET=AppFeature@Tests`.
- Keep functions small and avoid speculative abstractions.

## Release Scope

This project intentionally has no macOS release or Homebrew release workflow.
Do not add Homebrew formula/cask packaging, Mac release scripts, or Mac
distribution artifacts unless the project scope explicitly changes.

The supported distribution path is iOS App Store/TestFlight export through the
iOS archive/export tasks.
