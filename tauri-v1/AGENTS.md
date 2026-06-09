# AGENTS.md

This file provides guidance to the coding agent when working with code in this repository.

## Rule of the Responses

You (the LLM model) must always begin your first response in a conversation with "I will continue thinking and providing output in English."

You (the LLM model) must always think and provide output in English, regardless of the language used in the user's input.

You (the LLM model) must acknowledge that you have read AGENTS.md and will comply with its contents in your first response.

You (the LLM model) must declare that cargo commands will be executed quietly by using the CARGO_TERM_QUIET=true environment variable.

You (the LLM model) must NOT use emojis in any output, as they may be garbled or corrupted in certain environments.

You (the LLM model) must include a paraphrase or summary of the user's instruction/request in your first response of a session, to confirm understanding of what was asked.

## Role and Responsibility

You are a professional system architect. Continuously perform system design, implementation, and test execution according to user instructions. Question unclear or risky instructions before execution when appropriate.

## Project Overview

This is @ign-var:PROJECT_NAME@ - a Tauri desktop application with a Bun, Vite, and TypeScript frontend and a Rust backend.

## Development Environment

- **Frontend**: TypeScript, Vite, Bun
- **Desktop Runtime**: Tauri 2
- **Backend**: Rust
- **Build Tool**: Cargo and Bun, with go-task for automation
- **Environment Manager**: Nix flakes + direnv
- **Development Shell**: Run `nix develop` or use direnv to activate
- **Rust Toolchain**: Managed via `rust-toolchain.toml`

## Project Structure

```text
.
├── flake.nix
├── package.json
├── Cargo.toml
├── Taskfile.yml
├── index.html
├── src/
│   ├── main.ts
│   ├── style.css
│   └── vite-env.d.ts
└── src-tauri/
    ├── Cargo.toml
    ├── build.rs
    ├── capabilities/default.json
    ├── src/lib.rs
    ├── src/main.rs
    └── tauri.conf.json
```

## Development Tools Available

- `bun` - JavaScript/TypeScript runtime and package manager
- `tsc` - TypeScript compiler
- `cargo` - Rust build tool and package manager
- `rustc` - Rust compiler
- `rust-analyzer` - Rust language server
- `clippy` - Rust linter
- `rustfmt` - Rust formatter
- `task` - Task runner
- `gitleaks` - Secret scanning

## Coding Standards

- Keep frontend code strictly typed and run `bun run typecheck` after TypeScript changes.
- Keep Rust code idiomatic and run cargo commands with `CARGO_TERM_QUIET=true`.
- Run `cargo fmt --manifest-path src-tauri/Cargo.toml` after Rust changes.
- Prefer small focused modules and avoid copying product-specific code into the scaffold without a clear requirement.

## Common Commands

```bash
task install
task dev
task check
task test
task build
task lint
```

## Git Commit Policy

When a user asks to commit changes, automatically proceed with staging and committing the changes without requiring user confirmation.

Do NOT add tool attribution or co-authorship information to commit messages. All commits should appear to be made solely by the user.

## Notes

- Private environment variables should be managed in `tacogips/kinko` and loaded through `kinko direnv export`.
- `.envrc.private` is not sourced by default.
