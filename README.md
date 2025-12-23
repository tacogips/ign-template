# ign-template

A template repository for [ign](https://github.com/tacogips/ign), a CLI tool for project scaffolding through template-based code generation.

## What is ign?

ign is a CLI tool for initializing projects from templates. It downloads templates from GitHub repositories and generates new projects through variable substitution with a simple single-command workflow.

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

Use `ign checkout` to initialize and generate a project in a single step:

```bash
# From GitHub
ign checkout github.com/tacogips/ign-template/go-v1

# With output directory
ign checkout github.com/tacogips/ign-template/go-v1 ./my-project

# From local path
ign checkout ./go-v1 ./my-project

# Preview without writing files
ign checkout github.com/tacogips/ign-template/go-v1 --dry-run
```

The command will:
1. Create `.ign` directory with configuration
2. Interactively prompt for template variables
3. Generate project files from the template

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
@ign-var:PORT:int=8080@                   # Integer variable with default
@ign-var:DEBUG:bool=false@                # Boolean with default
```

### Conditionals

```
@ign-if:FEATURE_ENABLED@
  This appears when FEATURE_ENABLED is truthy
@ign-endif@

@ign-if:!FEATURE_DISABLED@
  This appears when FEATURE_DISABLED is falsy
@ign-endif@
```

### Other Directives

| Directive | Usage |
|-----------|-------|
| `@ign-if:VAR@...@ign-endif@` | Conditional block (bool) |
| `@ign-include:PATH@` | Include another file |
| `@ign-raw@...@ign-endraw@` | Output literally (escape processing) |
| `@ign-comment@...@ign-endcomment@` | Template-only comment (removed from output) |

## ign Commands Reference

### Global Flags

These flags apply to all commands:

| Flag | Description |
|------|-------------|
| `--no-color` | Disable colored output |
| `--quiet`, `-q` | Suppress non-error output |
| `--debug` | Enable debug logging |

### `ign checkout <url-or-path> [output-path]`

Initialize and generate project from template in a single step.

```bash
# From GitHub
ign checkout github.com/owner/repo
ign checkout github.com/owner/repo ./my-project
ign checkout github.com/owner/repo --ref v1.0.0

# From local path
ign checkout ./my-local-template ./output
```

**Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--ref` | `-r` | Git branch, tag, or commit SHA (default: main) |
| `--force` | `-f` | Backup and reinitialize existing config, overwrite files |
| `--dry-run` | `-d` | Show what would be generated without writing |
| `--verbose` | `-v` | Show detailed processing information |

**Behavior:**

| Condition | Action |
|-----------|--------|
| `.ign/` does not exist | Create `.ign/` and prompt for variables |
| `.ign/` exists | Error (use --force to reinitialize) |
| `.ign/` exists + `--force` | Backup existing config, reinitialize |

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

### `ign template collect-vars [PATH]`

Collect variables from templates and update ign.json.

```bash
ign template collect-vars           # Current directory
ign template collect-vars ./my-template
ign template collect-vars -r        # Recursive scan
ign template collect-vars --dry-run # Preview changes
ign template collect-vars --merge   # Only add new variables
```

**Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--recursive` | `-r` | Recursively scan subdirectories |
| `--dry-run` | | Preview changes without writing |
| `--merge` | | Only add new variables, preserve existing |

### `ign template new [PATH]`

Create a new template scaffold.

```bash
ign template new                    # Create in ./my-template
ign template new ./my-template
ign template new ./my-go-app --type go
ign template new --force ./existing-dir
```

**Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--type` | `-t` | Scaffold type (default, go, web) |
| `--force` | `-f` | Overwrite existing files |

### `ign version`

Show version information.

```bash
ign version
```

## Template Repository Structure

Templates use `ign.json` to define metadata and variables:

```json
{
  "name": "my-template",
  "version": "1.0.0",
  "description": "Template description",
  "author": "",
  "repository": "",
  "license": "MIT",
  "tags": [],
  "variables": {
    "PROJECT_NAME": {
      "type": "string",
      "description": "Project name",
      "required": true,
      "example": "my-project"
    },
    "PORT": {
      "type": "int",
      "description": "Server port",
      "default": 8080
    },
    "ENABLE_FEATURE": {
      "type": "bool",
      "description": "Enable optional feature",
      "default": false
    }
  },
  "settings": {
    "preserve_executable": false,
    "ignore_patterns": [".git", ".DS_Store"],
    "include_dotfiles": false
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
ign checkout github.com/private/repo
```

2. `GITHUB_TOKEN` environment variable

```bash
export GITHUB_TOKEN=ghp_xxx
ign checkout github.com/owner/private-repo
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
