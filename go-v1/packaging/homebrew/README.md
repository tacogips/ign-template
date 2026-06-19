# Homebrew Packaging

Homebrew releases install a standalone Go binary from GitHub Release assets.
The published archive contains `bin/@ign-var:PROJECT_NAME={current_dir}@`.

Build release archives:

```bash
scripts/build-homebrew-release.sh darwin-arm64 darwin-x64 linux-arm64 linux-x64
```

The command writes archives and checksum files under `dist/homebrew/`.

Create or update the GitHub release named `v<version>` with those archives, then
render the formula into the tap checkout:

```bash
scripts/render-homebrew-formula.sh <version> ../homebrew-tap/Formula/@ign-var:PROJECT_NAME={current_dir}@.rb
```

For the default Taskfile wrappers:

```bash
task build:homebrew -- darwin-arm64 darwin-x64 linux-arm64 linux-x64
task homebrew:formula -- <version>
task homebrew:tap-formula -- <version>
```

Verify from the tap checkout:

```bash
ruby -c Formula/@ign-var:PROJECT_NAME={current_dir}@.rb
brew audit --strict @ign-var:PROJECT_NAME={current_dir}@ || brew audit --strict --formula @ign-var:PROJECT_NAME={current_dir}@
brew install @ign-var:HOMEBREW_TAP=user/tap@/@ign-var:PROJECT_NAME={current_dir}@
brew test @ign-var:HOMEBREW_TAP=user/tap@/@ign-var:PROJECT_NAME={current_dir}@
```
