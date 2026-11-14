# Architecture

## Overview

This app is organized as a SwiftPM package plus an Xcode iOS app wrapper.

- `Sources/@ign-var:IOS_APP_TARGET=App@` contains the SwiftUI app entry point.
- `Sources/@ign-var:IOS_FEATURE_TARGET=AppFeature@` contains feature state and reusable SwiftUI views.
- `Tests/@ign-var:IOS_FEATURE_TARGET=AppFeature@Tests` contains SwiftPM tests.

The Xcode project references the local Swift package and links the feature
library into the iOS app target.

## Release Scope

The supported distribution path is iOS App Store/TestFlight. This project does
not include macOS app release or Homebrew release tooling.
