# Architecture

## Status

Draft

## Overview

`@ign-var:PROJECT_NAME={current_dir}@` is a Swift Package Manager project with a
library target, an executable target, tests, and release automation for Homebrew.

## Targets

- `@ign-var:SWIFT_LIBRARY_TARGET=AppCore@`: domain and command logic
- `@ign-var:SWIFT_EXECUTABLE_TARGET=AppCLI@`: command line entry point
- `@ign-var:SWIFT_LIBRARY_TARGET=AppCore@Tests`: package tests

## Release Surfaces

- Homebrew formula archives under `dist/homebrew/`
- Signed and notarized Cask DMGs under `dist/homebrew-cask/`
