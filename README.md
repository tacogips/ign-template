# ign-template

A template repository for [ign](https://github.com/tacogips/ign), a CLI tool for project scaffolding through template-based code generation.

## What is ign?

ign is a project scaffolding tool that downloads templates from GitHub repositories and generates new projects through variable substitution. It follows a simple workflow:

1. **Init**: Download template and create configuration
2. **Checkout**: Generate project files using the configuration

## Quick Start

### Installation

```bash
# Using Nix
nix run github:tacogips/ign

# From source
go install github.com/tacogips/ign@latest

# Or use in development shell
nix develop github:tacogips/ign-template
ign --help
```

### Using This Template

**Step 1: Initialize Configuration**

```bash
ign init github.com/tacogips/ign-template
```

This creates `.ign-config/ign-var.json` with template variables.

**Step 2: Configure Variables**

Edit `.ign-config/ign-var.json` to set your project-specific values.

**Step 3: Generate Project**

```bash
ign checkout .              # Generate to current directory
ign checkout ./my-project   # Generate to specific directory
```

## Template Syntax

ign uses `@ign-` prefix for template directives:

### Variables

| Syntax | Required | Description |
|--------|----------|-------------|
| `@ign-var:NAME@` | Yes | Basic variable |
| `@ign-var:NAME:TYPE@` | Yes | With type validation |
| `@ign-var:NAME=DEFAULT@` | No | With default value |
| `@ign-var:NAME:TYPE=DEFAULT@` | No | With type and default |

**Types:** `string`, `int`, `bool`

**Examples:**

```
@ign-var:PROJECT_NAME@                    # Required variable
@ign-var:AUTHOR=John Doe@                 # Variable with default
@ign-var:PORT:int=8080@                   # Typed variable with default
@ign-var:DEBUG:bool=false@                # Boolean with default
```

### Conditionals

```
@ign-if:FEATURE_ENABLED@
  This appears when FEATURE_ENABLED is truthy
@ign-endif@
```

### Other Directives

| Directive | Usage |
|-----------|-------|
| `@ign-if:VAR@...@ign-endif@` | Conditional block (bool) |
| `@ign-include:PATH@` | Include another file |
| `@ign-raw:CONTENT@` | Output literally (escape) |
| `@ign-comment:TEXT@` | Template-only comment (removed) |

## ign Commands Reference

### Global Flags

These flags apply to all commands:

| Flag | Description |
|------|-------------|
| `--no-color` | Disable colored output |
| `--quiet`, `-q` | Suppress non-error output |
| `--debug` | Enable debug output |

### `ign init <url-or-path>`

Initialize configuration from a template source.

```bash
# From GitHub
ign init github.com/owner/repo
ign init github.com/owner/repo/path/to/template
ign init github.com/owner/repo --ref v1.0.0

# From local path
ign init ./my-local-template
ign init /absolute/path/to/template
```

**Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--ref` | `-r` | Git branch, tag, or commit SHA (default: main) |
| `--force` | `-f` | Backup existing config and reinitialize |

**Behavior:**

| Condition | Action |
|-----------|--------|
| `.ign-config/` does not exist | Create `.ign-config/ign-var.json` |
| `.ign-config/` exists | Do nothing (skip) |
| `.ign-config/` exists + `--force` | Backup existing config, then reinitialize |

**Backup naming:** When `--force` is used, existing `ign-var.json` is backed up as `ign-var.json.bk1`, `ign-var.json.bk2`, etc.

### `ign checkout <path>`

Generate project files to the specified path using existing `.ign-config/`.

```bash
ign checkout .              # Generate to current directory
ign checkout ./my-project   # Generate to specific directory
ign checkout sub_dir        # Generate to subdirectory
ign checkout . --dry-run    # Preview without writing files
ign checkout . --verbose    # Show detailed processing info
```

**Requires:** `.ign-config/ign-var.json` must exist (run `ign init` first).

**Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--force` | `-f` | Overwrite existing files |
| `--dry-run` | `-d` | Show what would be generated without writing |
| `--verbose` | `-v` | Show detailed processing information |

**File handling:**

| Condition | Action |
|-----------|--------|
| File does not exist | Create |
| File exists | Skip (do not overwrite) |
| File exists + `--force` | Overwrite |

### `ign template check [PATH]`

Validate template files for syntax errors.

```bash
ign template check              # Check current directory
ign template check ./templates  # Check specific directory
ign template check -r           # Recursive check
ign template check -r -v        # Recursive with verbose output
```

**Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--recursive` | `-r` | Recursively check subdirectories |
| `--verbose` | `-v` | Show detailed validation info |

### `ign version`

Show version information.

```bash
ign version          # Full version info
ign version --short  # Version number only
ign version --json   # JSON format output
```

## Configuration Directory

`.ign-config/` contains:

```
.ign-config/
  ign-var.json         # Template reference and variable values
  license-header.txt   # Optional files for @file: references
```

### ign-var.json Structure

```json
{
  "template": {
    "url": "github.com/owner/templates/go-basic",
    "ref": "main"
  },
  "variables": {
    "app_name": "my-app",
    "port": 8080,
    "debug": false
  }
}
```

## Template Repository Access

### Public Repositories

No authentication required. Supported URL formats:

- Full HTTPS: `https://github.com/owner/repo`
- Short form: `github.com/owner/repo`
- Owner/repo: `owner/repo`
- With path: `github.com/owner/repo/templates/go-basic`
- Git SSH: `git@github.com:owner/repo.git`
- Specific ref: `--ref v1.2.0` or `--ref branch-name`

### Private Repositories

Requires GitHub authentication via either:

1. GitHub CLI (recommended)

```bash
gh auth login
ign init github.com/private/repo
```

2. `GITHUB_TOKEN` environment variable

```bash
export GITHUB_TOKEN=ghp_xxx
ign init github.com/owner/private-repo
```

## Development Environment

This template includes a Nix flake for reproducible development:

```bash
# Enter development shell
nix develop

# Or use direnv for automatic activation
direnv allow
```

### Available Tools

- Go toolchain (go, gofmt, gopls)
- go-task (Task runner)
- golangci-lint (Linter)
- ign (Template tool)

### Project Structure

```
.
├── flake.nix          # Nix flake configuration
├── flake.lock         # Locked dependencies
├── .envrc             # direnv configuration
└── .gitignore         # Git ignore patterns
```

## Issue Reporting

**ign is not yet stable and may have unexpected behavior.** If you encounter any issues:

1. **Do NOT try to work around or fix manually**
2. **Create an issue at https://github.com/tacogips/ign/issues**
3. Include:
   - Command that caused the problem
   - Expected vs actual behavior
   - Error messages or output
   - Template structure if relevant
   - ign version (`ign version`)

This helps improve ign for everyone.

## License

See LICENSE file for details.
