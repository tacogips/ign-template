# @ign-var:PROJECT_NAME@

@ign-var:DESCRIPTION@

This project is a Tauri desktop app with a Bun, Vite, and TypeScript frontend and a Rust backend.

## Development

```bash
bun install
task dev
```

## Common Tasks

```bash
task check
task test
task build
task tauri-build
task lint
```

## Nix

```bash
nix develop
```

The development shell includes Bun, TypeScript tooling, Rust tooling, Tauri build dependencies, go-task, and gitleaks.

## Metadata

- Homepage: @ign-var:HOMEPAGE@
- Repository: @ign-var:REPOSITORY@
@ign-if:HAS_AUTHOR@
- Author: @ign-var:AUTHOR_NAME@ <@ign-var:AUTHOR_EMAIL@>
@ign-endif@
