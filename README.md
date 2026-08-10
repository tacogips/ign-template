# ign-template

A template repository for [ign](https://github.com/tacogips/ign), a CLI tool for project scaffolding through template-based code generation.

## What is ign?

ign is a CLI tool for initializing projects from templates. It downloads templates from GitHub repositories and generates new projects through variable substitution with a simple single-command workflow.

For detailed usage, installation instructions, and command reference, see the [ign README](https://github.com/tacogips/ign#readme).

## Quick Start

```bash
# Install the tools declared by this repository
mise install

# Use this template
ign checkout github.com/tacogips/ign-template/go-v1 ./my-project
```

## Available Templates

| Template | Description |
|----------|-------------|
| `go-v1` | Go project with mise configuration, Claude Code configuration |
| `general-v1` | General investigation workspace with browser tooling and reusable agent skills |
| `ios-app-v1` | SwiftUI iOS app with SwiftPM modules, Xcode project wrapper, simulator checks, and iOS archive/export helpers |
| `python-v1` | Modern Python project with uv, src layout, Ruff, and pytest |
| `swift-v1` | SwiftPM project with mise, Homebrew formula, and macOS Cask release support |
| `tauri-v1` | Tauri desktop app with Bun, Vite, TypeScript, Rust, and mise configuration |

## Using Templates

```bash
# From GitHub
ign checkout github.com/tacogips/ign-template/go-v1
ign checkout github.com/tacogips/ign-template/general-v1
ign checkout github.com/tacogips/ign-template/ios-app-v1
ign checkout github.com/tacogips/ign-template/python-v1
ign checkout github.com/tacogips/ign-template/swift-v1
ign checkout github.com/tacogips/ign-template/tauri-v1

# With output directory
ign checkout github.com/tacogips/ign-template/go-v1 ./my-project
ign checkout github.com/tacogips/ign-template/general-v1 ./my-investigation
ign checkout github.com/tacogips/ign-template/ios-app-v1 ./my-ios-app
ign checkout github.com/tacogips/ign-template/python-v1 ./my-python-project
ign checkout github.com/tacogips/ign-template/swift-v1 ./my-swift-project
ign checkout github.com/tacogips/ign-template/tauri-v1 ./my-tauri-app

# Preview without writing files
ign checkout github.com/tacogips/ign-template/go-v1 --dry-run
ign checkout github.com/tacogips/ign-template/general-v1 --dry-run
ign checkout github.com/tacogips/ign-template/ios-app-v1 --dry-run
ign checkout github.com/tacogips/ign-template/python-v1 --dry-run
ign checkout github.com/tacogips/ign-template/swift-v1 --dry-run
ign checkout github.com/tacogips/ign-template/tauri-v1 --dry-run
```

## Development Environment

This repository includes a mise configuration for reproducible tooling and tasks:

```bash
# Install ign and the repository development tools
mise install
```

With `mise activate bash` enabled, entering this repository automatically
loads its scope-aware kinko environment when kinko 0.1.10 or newer is installed.
Without a compatible kinko, the hook is a no-op. Kinko tracks the exported
variable names and unsets them when leaving the repository. Never commit secret
values.

## Issue Reporting

**ign is not yet stable and may have unexpected behavior.** If you encounter any issues:

1. **Do NOT try to work around or fix manually**
2. **Create an issue at https://github.com/tacogips/ign/issues**
3. Include:
   - Command that caused the problem
   - Expected vs actual behavior
   - Error messages or output
   - ign version (`ign version`)

## License

See LICENSE file for details.
