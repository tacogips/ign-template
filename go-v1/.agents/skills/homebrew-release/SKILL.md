---
name: homebrew-release
description: Use when building, validating, publishing, or tap-rendering Homebrew formula releases for this Go project, including scripts/build-homebrew-release.sh, scripts/render-homebrew-formula.sh, Taskfile Homebrew tasks, GitHub Release assets, and tap formula verification.
---

# Homebrew Release

Use this skill for Formula releases installed with:

```bash
brew tap @ign-var:HOMEBREW_TAP=user/tap@
brew install @ign-var:PROJECT_NAME={current_dir}@
```

## Release Contract

1. Confirm `internal/build/VERSION` is the intended release version.
2. Run local build and tests.
3. Build Homebrew tarballs with `scripts/build-homebrew-release.sh`.
4. Publish GitHub Release assets only when explicitly requested.
5. Render the formula only after all referenced archives and checksums exist.
6. Update, commit, push, and verify the tap formula after the GitHub Release is
   available.

Expected asset mapping:

| Homebrew platform | Release asset |
| --- | --- |
| macOS Apple Silicon | `@ign-var:PROJECT_NAME={current_dir}@-<version>-darwin-arm64.tar.gz` |
| macOS Intel | `@ign-var:PROJECT_NAME={current_dir}@-<version>-darwin-x64.tar.gz` |
| Linux ARM64 | `@ign-var:PROJECT_NAME={current_dir}@-<version>-linux-arm64.tar.gz` |
| Linux x86_64 | `@ign-var:PROJECT_NAME={current_dir}@-<version>-linux-x64.tar.gz` |

## Standard Commands

Build:

```bash
task test
task build:homebrew -- darwin-arm64 darwin-x64 linux-arm64 linux-x64
```

Render locally:

```bash
version="$(tr -d '[:space:]' < internal/build/VERSION)"
task homebrew:formula -- "$version"
```

Render into the default sibling tap:

```bash
version="$(tr -d '[:space:]' < internal/build/VERSION)"
task homebrew:tap-formula -- "$version"
```

## Publishing

Before rendering a public formula, ensure the release assets exist:

```bash
version="$(tr -d '[:space:]' < internal/build/VERSION)"
gh release view "v${version}" --repo @ign-var:GITHUB_REPOSITORY=user/repo@
```

If publishing is explicitly requested:

```bash
version="$(tr -d '[:space:]' < internal/build/VERSION)"
gh release upload "v${version}" \
  "dist/homebrew/@ign-var:PROJECT_NAME={current_dir}@-${version}-darwin-arm64.tar.gz" \
  "dist/homebrew/@ign-var:PROJECT_NAME={current_dir}@-${version}-darwin-x64.tar.gz" \
  "dist/homebrew/@ign-var:PROJECT_NAME={current_dir}@-${version}-linux-arm64.tar.gz" \
  "dist/homebrew/@ign-var:PROJECT_NAME={current_dir}@-${version}-linux-x64.tar.gz" \
  --repo @ign-var:GITHUB_REPOSITORY=user/repo@ \
  --clobber
```

## Verification

From the tap checkout:

```bash
ruby -c Formula/@ign-var:PROJECT_NAME={current_dir}@.rb
brew audit --strict @ign-var:PROJECT_NAME={current_dir}@ || brew audit --strict --formula @ign-var:PROJECT_NAME={current_dir}@
brew install @ign-var:HOMEBREW_TAP=user/tap@/@ign-var:PROJECT_NAME={current_dir}@
brew test @ign-var:HOMEBREW_TAP=user/tap@/@ign-var:PROJECT_NAME={current_dir}@
```

If online audit fails due network, GitHub credentials, or rate limits, run the
non-online audit and report the limitation.
