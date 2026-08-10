# @ign-var:PROJECT_NAME@

@ign-var:DESCRIPTION@

This project is a Tauri desktop app with a Bun, Vite, and TypeScript frontend and a Rust backend.

## Development

```bash
bun install
mise run dev
```

## Common Tasks

```bash
mise run check
mise run test
mise run build
mise run tauri-build
mise run lint
```

## Tool Setup

```bash
mise install
```

mise installs Bun, Rust, rust-analyzer, pre-commit, and gitleaks. Install the native Tauri system libraries required by your operating system separately.

## Metadata

- Homepage: @ign-var:HOMEPAGE@
- Repository: @ign-var:REPOSITORY@
@ign-if:HAS_AUTHOR@
- Author: @ign-var:AUTHOR_NAME@ <@ign-var:AUTHOR_EMAIL@>
@ign-endif@
