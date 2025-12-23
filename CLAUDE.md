# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Rule of the Responses

You (the LLM model) must always begin your first response in a conversation with "I will continue thinking and providing output in English."

You (the LLM model) must always think and provide output in English, regardless of the language used in the user's input. Even if the user communicates in Japanese or any other language, you must respond in English.

You (the LLM model) must acknowledge that you have read CLAUDE.md and will comply with its contents in your first response.

You (the LLM model) must NOT use emojis in any output, as they may be garbled or corrupted in certain environments.

## Role and Responsibility

You are a professional system architect. You will continuously perform system design, implementation, and test execution according to user instructions. However, you must always consider the possibility that user instructions may contain unclear parts, incorrect parts, or that the user may be giving instructions based on a misunderstanding of the system. You have an obligation to prioritize questioning the validity of execution and asking necessary questions over executing tasks when appropriate, rather than simply following user instructions as given.

## Language Instructions

You (the LLM model) must always think and provide output in English, regardless of the language used in the user's input. Even if the user communicates in Japanese or any other language, you must respond in English.

## Session Initialization Requirements

When starting a new session, you (the LLM model) should be ready to assist the user with their requests immediately without any mandatory initialization process.

## Git Commit Policy

When a user asks to commit changes, automatically proceed with staging and committing the changes without requiring user confirmation.

**IMPORTANT**: Do NOT add any Claude Code attribution or co-authorship information to commit messages. All commits should appear to be made solely by the user. Specifically:

- Do NOT include `Generated with [Claude Code](https://claude.ai/code)`
- Do NOT include `Co-Authored-By: Claude <noreply@anthropic.com>`
- The commit should appear as if the user made it directly

**Automatic Commit Process**: When the user requests a commit, automatically:

a) Stage the files with `git add`
b) Show a summary that includes:

- The commit message
- Files to be committed with diff stats (using `git diff --staged --stat`)
  c) Create and execute the commit with the message
  d) Show the commit result to the user

Summary format example:

```
COMMIT SUMMARY

FILES TO BE COMMITTED:

────────────────────────────────────────────────────────

[output of git diff --staged --stat]

────────────────────────────────────────────────────────

COMMIT MESSAGE:
[commit message summary]

UNRESOLVED TODOs:
- [ ] [TODO item 1 with file location]
- [ ] [TODO item 2 with file location]
```

Note: When displaying file changes, use status indicators:

- D: Deletions
- A: Additions
- M: Modifications
- R: Renames

### Git Commit Message Guide

Git commit messages should follow this structured format to provide comprehensive context about the changes:

Create a detailed summary of the changes made, paying close attention to the specific modifications and their impact on the codebase.
This summary should be thorough in capturing technical details, code patterns, and architectural decisions.

Before creating your final commit message, analyze your changes and ensure you've covered all necessary points:

1. Identify all modified files and the nature of changes made
2. Document the purpose and motivation behind the changes
3. Note any architectural decisions or technical concepts involved
4. Include specific implementation details where relevant

Your commit message should include the following sections:

1. Primary Changes and Intent: Capture the main changes and their purpose in detail
2. Key Technical Concepts: List important technical concepts, technologies, and frameworks involved
3. Files and Code Sections: List specific files modified or created, with summaries of changes made
4. Problem Solving: Document any problems solved or issues addressed
5. Impact: Describe the impact of these changes on the overall project
6. Unresolved TODOs: If there are any remaining tasks, issues, or incomplete work, list them using TODO list format with checkboxes `- [ ]`

Example commit message format:

```
feat: implement user authentication system

1. Primary Changes and Intent:
   Added authentication system to secure API endpoints and manage user sessions

2. Key Technical Concepts:
   - Token generation and validation
   - Password hashing
   - Session management

3. Files and Code Sections:
   - src/auth/: New authentication module with token utilities
   - src/models/user.go: User model with password hashing
   - src/routes/auth.go: Login and registration endpoints

4. Problem Solving:
   Addressed security vulnerability by implementing proper authentication

5. Impact:
   Enables secure user access control across the application

6. Unresolved TODOs:
   - [ ] src/auth/auth.go:45: Add rate limiting for login attempts
   - [ ] src/routes/auth.go:78: Implement password reset functionality
   - [ ] tests/: Add integration tests for authentication flow
```

## Project Overview

This is a template repository for ign (https://github.com/tacogips/ign), a project scaffolding tool. This repository is used to create and manage templates that can be consumed by the ign CLI tool.

## About ign

ign is a CLI tool for project scaffolding that downloads templates from GitHub repositories and generates new projects through variable substitution.

### ign Installation

ign is available in the Nix development environment via flake input:

```bash
# Enter development shell (ign will be available)
nix develop

# Or run directly without entering shell
nix run github:tacogips/ign -- --help
```

### ign Workflow

**Checkout (Initialize and Generate)**

```bash
ign checkout <url-or-path> [output-path]
```

This command combines initialization and checkout into a single step:
1. Creates `.ign` directory with configuration
2. Interactively prompts for template variables
3. Generates project files from the template

URL formats supported:
- Full HTTPS: `https://github.com/owner/repo`
- Short form: `github.com/owner/repo`
- Owner/repo: `owner/repo`
- With path: `github.com/owner/repo/templates/go-basic`
- Git SSH: `git@github.com:owner/repo.git`
- Local path: `./my-local-template` or `/absolute/path`
- Specific ref: `--ref v1.2.0` or `--ref branch-name`

**Examples:**
```bash
ign checkout github.com/owner/repo
ign checkout github.com/owner/repo ./my-project
ign checkout github.com/owner/repo --ref v1.2.0
ign checkout ./my-local-template ./output
ign checkout github.com/owner/repo --force
ign checkout github.com/owner/repo --dry-run
```

### ign Commands Reference

**Checkout (Project Generation)**
```bash
ign checkout <url-or-path> [output-path]  # Initialize and generate project
  -r, --ref string             # Git branch, tag, or commit (default "main")
  -f, --force                  # Backup and reinitialize existing config, overwrite files
  -d, --dry-run                # Show what would be generated without writing files
  -v, --verbose                # Show detailed processing information
```

**Template Management**
```bash
ign template check [PATH]      # Validate template files for syntax errors
  -r, --recursive              # Check subdirectories recursively
  -v, --verbose                # Show detailed validation info

ign template update [PATH]     # Collect variables from templates and update ign.json with hash
  --dry-run                    # Preview changes without writing
  --merge                      # Only add new variables, preserve existing
  -r, --recursive              # Recursively scan subdirectories

ign template new [PATH]        # Create a new template scaffold
  -t, --type string            # Scaffold type (default, go, web)
  -f, --force                  # Overwrite existing files
```

**Project Update (for generated projects)**
```bash
ign update [output-path]       # Update project from template changes
  -d, --dry-run                # Preview what files would be generated
  -f, --force                  # Overwrite existing files
  -v, --verbose                # Show detailed processing information
```

**Global Flags**
```bash
--debug                        # Enable debug logging
--no-color                     # Disable colored output
-q, --quiet                    # Suppress non-error output
```

### Template Syntax

ign templates use `@ign-` prefix for directives to avoid conflicts with programming language syntax.

**Variables**
```
@ign-var:NAME@                           # Required variable
@ign-var:NAME:default_value@             # Variable with default
@ign-var:NAME:string:default@            # Typed variable (string, int, bool)
```

**Conditionals**
```
@ign-if:VAR@
  Content shown if VAR is truthy
@ign-endif@

@ign-if:!VAR@
  Content shown if VAR is falsy
@ign-endif@
```

**File Inclusion**
```
@ign-include:path/to/file.txt@           # Include file content
```

**Raw Content (Escape Processing)**
```
@ign-raw@
  This content is not processed by ign
  @ign-var:FOO@ will appear literally
@ign-endraw@
```

**Template-Only Comments**
```
@ign-comment@
  This comment will not appear in generated output
@ign-endcomment@
```

### Template Repository Access

**Public Repositories**
No authentication required.

**Private Repositories**
Requires GitHub authentication via either:

1. GitHub CLI (`gh` command must be authenticated)
2. `GITHUB_TOKEN` environment variable

```bash
export GITHUB_TOKEN="your_github_token"
ign checkout github.com/owner/private-repo
```

### IMPORTANT: Issue Reporting

**ign is not yet stable and may have unexpected behavior.** If you encounter any bugs, strange behavior, or issues while using ign:

1. **Do NOT try to work around or fix issues manually**
2. **Create an issue at https://github.com/tacogips/ign/issues**
3. Include in the issue:
   - Command that caused the problem
   - Expected behavior vs actual behavior
   - Error messages or unexpected output
   - Template structure if relevant
   - ign version (`ign version`)

This helps improve ign for everyone and ensures issues are tracked and resolved properly.

## Development Environment
- **Language**: Go
- **Build Tool**: go-task (Task runner)
- **Environment Manager**: Nix flakes + direnv
- **Development Shell**: Run `nix develop` or use direnv to activate

## Project Structure
```
.
├── flake.nix          # Nix flake configuration for Go development
├── flake.lock         # Locked flake dependencies
├── .envrc             # direnv configuration
└── .gitignore         # Git ignore patterns
```

## Development Tools Available
- `go` - Go compiler and toolchain
- `gopls` - Go language server (LSP)
- `gotools` - Additional Go development tools
- `task` - Task runner (go-task)
- `ign` - Template-based project scaffolding tool (available in nix develop)

## Coding Standards
- Follow standard Go conventions and idioms
- Use `gofmt` for code formatting
- Write clear, concise comments for exported functions
- Keep functions focused and single-purpose
- Avoid over-engineering - implement only what's requested

## Go Code Development
**IMPORTANT**: When writing Go code, you (the LLM model) MUST use the specialized go-coding sub agent located at `.claude/agents/go-coding.md`.

Use the Task tool with the go-coding agent for:
- Writing new Go code
- Refactoring existing Go code
- Implementing Go packages and modules
- Following Standard Go Project Layout
- Implementing layered architecture (Clean Architecture, Hexagonal Architecture, etc.)

The go-coding agent has comprehensive knowledge of:
- Standard Go Project Layout conventions
- Go best practices and idioms
- Layered architecture patterns
- CLI/TUI application structures
- Package management with go modules

### What go-coding Subagent Does

The go-coding subagent **actually implements the code**, not just provides guidance. It will:

1. Read the reference document to understand requirements
2. Analyze existing codebase structure
3. Create/modify Go files using Edit/Write tools
4. Run `go mod tidy` to sync dependencies
5. Run `go build` and `go test` to verify implementation
6. Return results as **diff format**

### Required Prompt Format

When invoking the go-coding subagent via Task tool, the `prompt` parameter MUST include the following information. The subagent will return an error and refuse to proceed if any required field is missing.

**Required Fields:**

1. **Purpose**: What goal or problem does this implementation solve?
2. **Reference Document**: Which specification, design document, or requirements to follow?
3. **Implementation Target**: What specific feature, function, or component to implement?
4. **Completion Criteria**: What conditions define "implementation complete"?

**Example Task Tool Invocation:**

```
Task tool parameters:
  subagent_type: go-coding
  prompt: |
    Purpose: Implement the template variable parser for ign
    Reference Document: /docs/spec.md (Section: Template Syntax)
    Implementation Target: Create internal/parser/variable.go with ParseVariables function
    Completion Criteria:
      - ParseVariables extracts all {{variable}} patterns from input
      - Returns []Variable with name, default value, and source location
      - Unit tests cover edge cases (nested braces, escaped sequences)
      - go mod tidy runs without errors
```

**Do NOT invoke go-coding without all required fields.** The subagent will reject incomplete requests.

### Response Format from go-coding

The subagent returns a structured response including:

**On Success:**
- Summary of what was implemented
- Completion criteria status (checklist)
- Files changed with **file path and line numbers** (final code, not diff)
- Test results (`go test ./... -v`)
- Notes and follow-up items

**On Failure:**
- Reason for failure
- Partial progress made
- Partial files changed (same file:line format)
- Recommended next steps

**Note**: The subagent will iterate on build/test failures until they pass. It runs `go build`, `go test`, and `go vet` in sequence, fixing any issues before returning.

## Task Management
- Use `task` command for build automation
- Define tasks in `Taskfile.yml` (to be created as needed)

## Git Workflow
- Create meaningful commit messages
- Keep commits focused and atomic
- Follow conventional commit format when appropriate

## Implementation Progress Tracking

Implementation progress is tracked per specification item in `docs/progress/`:

### Directory Structure
```
docs/progress/
├── template-provider.md         # TemplateProvider implementation status
├── cli-commands.md              # CLI commands implementation status
├── template-syntax.md           # Template syntax parser implementation status
└── <feature-name>.md            # One file per major spec item
```

### Progress File Structure

Each feature progress file should include:

1. **Status**: `Not Started` | `In Progress` | `Completed`
2. **Spec Reference**: Link to relevant section in spec.md or reference docs
3. **Implemented**: List of completed sub-features with file paths
4. **Remaining**: List of sub-features not yet implemented
5. **Design Decisions**: Notable decisions made during implementation
6. **Notes**: Issues, considerations, or context for future work

Example format:
```markdown
# Feature Name

**Status**: In Progress

## Spec Reference
- docs/spec.md Section X.X
- docs/reference/xxx.md

## Implemented
- [x] Sub-feature A (`internal/pkg/file.go`)
- [x] Sub-feature B (`internal/pkg/other.go`)

## Remaining
- [ ] Sub-feature C
- [ ] Sub-feature D

## Design Decisions
- Decision 1: rationale

## Notes
- Any relevant notes
```

## Notes
- This project uses Nix flakes for reproducible development environments
- Use direnv for automatic environment activation
- All development dependencies are managed through flake.nix

## Claude Code Plugin Specification

This section documents the Claude Code plugin system based on official documentation and verified working configurations.

### References

- Plugin Overview: https://code.claude.com/docs/en/plugins
- Plugin Marketplaces: https://code.claude.com/docs/en/plugin-marketplaces
- Discover and Install Plugins: https://code.claude.com/docs/en/discover-plugins
- Settings Reference: https://code.claude.com/docs/en/settings

### Plugin vs Marketplace

| Concept | Description |
|---------|-------------|
| **Plugin** | A single extension unit containing commands, agents, skills, hooks, MCP/LSP servers |
| **Marketplace** | A DIRECTORY containing `.claude-plugin/marketplace.json` that registers multiple plugins |

### Plugin Directory Structure

```
my-plugin/                      # Plugin root
├── .claude-plugin/
│   └── plugin.json             # Plugin manifest (REQUIRED, ONLY this file here)
├── commands/                   # Slash commands (at plugin root, NOT in .claude-plugin/)
├── agents/                     # Custom agents
├── skills/                     # Agent Skills
├── hooks/                      # Event handlers
├── .mcp.json                   # MCP server configurations
└── .lsp.json                   # LSP server configurations
```

**Important**: Only `plugin.json` goes inside `.claude-plugin/`. All other directories (commands/, agents/, skills/, hooks/) must be at the plugin root level.

### plugin.json (Plugin Manifest)

```json
{
  "name": "my-plugin",
  "description": "Plugin description",
  "version": "1.0.0",
  "author": {
    "name": "Author Name"
  }
}
```

### Marketplace Structure

A marketplace is a **DIRECTORY** that contains `.claude-plugin/marketplace.json`:

```
marketplace-dir/                # Marketplace directory
├── .claude-plugin/
│   └── marketplace.json        # Marketplace definition (REQUIRED location)
└── plugins/                    # Plugins directory
    └── my-plugin/
        ├── .claude-plugin/
        │   └── plugin.json
        └── .lsp.json
```

**marketplace.json (inside .claude-plugin/):**
```json
{
  "name": "marketplace-name",
  "owner": {
    "name": "Owner Name",
    "email": "email@example.com"
  },
  "plugins": [
    {
      "name": "plugin-name",
      "source": "./plugins/my-plugin",
      "description": "Plugin description",
      "version": "1.0.0"
    }
  ]
}
```

**Important**: The `source` field is relative to the marketplace directory (where `.claude-plugin/marketplace.json` exists), NOT relative to the repository root.

### Project-Scoped Plugin Configuration (Recommended)

For a project with an embedded local marketplace at `.claude/marketplace/`:

```
project/
├── .claude/
│   ├── settings.json             # Only hooks + enabledPlugins
│   ├── marketplace/              # Local marketplace DIRECTORY
│   │   ├── .claude-plugin/
│   │   │   └── marketplace.json  # Marketplace definition
│   │   └── plugins/
│   │       └── lsp/
│   │           ├── .claude-plugin/
│   │           │   └── plugin.json
│   │           └── .lsp.json
│   ├── agents/
│   ├── commands/
│   └── ...
└── ...
```

**.claude/marketplace/.claude-plugin/marketplace.json:**
```json
{
  "name": "local",
  "owner": { "name": "Project" },
  "plugins": [
    {
      "name": "go-lsp",
      "source": "./plugins/lsp",
      "description": "Go language server support",
      "version": "1.0.0"
    }
  ]
}
```

**.claude/settings.json:**
```json
{
  "extraKnownMarketplaces": {
    "local": {
      "source": {
        "source": "directory",
        "path": ".claude/marketplace"
      }
    }
  },
  "enabledPlugins": {
    "go-lsp@local": true
  },
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "goimports -w ."
          }
        ]
      }
    ]
  }
}
```

**Note**: `extraKnownMarketplaces` with `source: "directory"` registers the marketplace at project scope. When team members clone the repo, they are prompted to install the marketplace. The path is relative to the repository root.

### Plugin Loading Methods

1. **Via .claude/marketplace/ directory (Project Scope, Recommended)**: Place marketplace at `.claude/marketplace/` with `.claude-plugin/marketplace.json` inside
2. **Via CLI flag (Development/Testing)**: `claude --plugin-dir ./path/to/plugin`
3. **Via /plugin command (Interactive)**: `/plugin marketplace add .claude/marketplace` then `/plugin install plugin@marketplace`

### Marketplace Source Types

| Type | Example |
|------|---------|
| `directory` | `{"source": "directory", "path": ".claude/marketplace"}` (for local project) |
| `github` | `{"source": "github", "repo": "owner/repo"}` |
| `git` | `{"source": "git", "url": "https://example.com/repo.git"}` |
| `url` | `{"source": "url", "url": "https://example.com/marketplace.json"}` |
| `npm` | `{"source": "npm", "package": "@org/plugins"}` |

### Key Points

- A marketplace is a DIRECTORY containing `.claude-plugin/marketplace.json`, not a standalone JSON file
- Use `extraKnownMarketplaces` in settings.json with `source: "directory"` for project-scoped marketplaces
- Plugin `source` paths in marketplace.json are relative to the marketplace directory
- `enabledPlugins` format is always `"plugin-name@marketplace-name": true`
- When team members clone the repo, they are prompted to install the marketplace
- Plugin components (commands/, agents/, etc.) must be at plugin root, not inside `.claude-plugin/`
