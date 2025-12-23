# ign-template

A template repository for [ign](https://github.com/tacogips/ign), a CLI tool for project scaffolding through template-based code generation.

## What is ign?

ign is a CLI tool for initializing projects from templates. It downloads templates from GitHub repositories and generates new projects through variable substitution with a simple single-command workflow.

For detailed usage, installation instructions, and command reference, see the [ign README](https://github.com/tacogips/ign#readme).

## Quick Start

```bash
# Install ign
nix run github:tacogips/ign

# Use this template
ign checkout github.com/tacogips/ign-template/go-v1 ./my-project
```

## Available Templates

| Template | Description |
|----------|-------------|
| `go-v1` | Go project with Nix flake, Claude Code configuration |

## Using Templates

```bash
# From GitHub
ign checkout github.com/tacogips/ign-template/go-v1

# With output directory
ign checkout github.com/tacogips/ign-template/go-v1 ./my-project

# Preview without writing files
ign checkout github.com/tacogips/ign-template/go-v1 --dry-run
```

## Development Environment

This template includes a Nix flake for reproducible development:

```bash
# Enter development shell (ign will be available)
nix develop

# Or use direnv for automatic activation
direnv allow
```

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
