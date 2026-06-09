# Tauri V1 Template Implementation Plan

**Status**: Completed
**Workflow Mode**: issue-resolution
**Issue Reference**: Create tauri-v1 ign template from chilla reference
**Design Reference**: `design-docs/specs/design-tauri-v1-template.md`
**Created**: 2026-06-04
**Last Updated**: 2026-06-04

---

## Source of Truth

Use `design-docs/specs/design-tauri-v1-template.md` as the accepted design.
Step 3 accepted the design with no high or mid findings.

The implementation must create a new root template at `tauri-v1/`, update the
repository `README.md`, and run:

- `ign template update tauri-v1`
- `ign template check tauri-v1`

If either ign command fails because ign behaves unexpectedly, do not silently
work around it. Record the command, expected behavior, actual behavior, and
output so an issue can be filed at `https://github.com/tacogips/ign/issues`.

## Codex-Agent References

- `AGENTS.md`: English-only output, no emoji, commit policy, and template repository rules.
- `bun-ts-v1`: Bun, TypeScript, Vite, Nix, Taskfile, metadata, and ign variable conventions.
- `rust-v1`: Rust metadata, Cargo variable patterns, rust-toolchain, Nix, and Taskfile conventions.
- `.agents/skills/template-editing/SKILL.md`: After template edits, run `ign template update` then `ign template check`, and review `ign-template.json` diff.
- Sibling `chilla` checkout: Structural reference only for Bun/Vite/Tauri/Rust project shape.

## Intentional Divergences

- `tauri-v1` is the ign template version name; the framework baseline follows chilla's Tauri v2 structure.
- Do not copy chilla product features: Markdown viewer, Git viewer, custom window chrome, file watcher, media streaming, release signing, notarization, DMG bundling, e2e scripts, or product-specific commands.
- Use explicit variables for `TAURI_IDENTIFIER`, `RUST_CRATE_NAME`, and `RUST_LIB_NAME`; do not assume ign can sanitize `PROJECT_NAME`.
- Use literal ign defaults only. Do not nest `@ign-var:*@` directives inside default values.

## Task Breakdown

### TASK-001: Establish `tauri-v1` Template Root

**Status**: Completed
**Write Scope**: `tauri-v1/` root metadata and ignore files
**Depends On**: None
**Parallelizable**: No

**Deliverables**:
- Create `tauri-v1/` as a new ign template root.
- Add initial `ign-template.json` metadata with name, description, tags, settings, and placeholder variables suitable for `ign template update`.
- Add `.gitignore` and `.ign-overwrite-ignore` based on `bun-ts-v1` and `rust-v1`, covering `node_modules`, `dist`, `target`, and local Tauri build outputs.
- Add template-level `AGENTS.md` if aligned with existing template conventions.

### TASK-002: Add Bun/Vite/TypeScript Frontend Scaffold

**Status**: Completed
**Write Scope**: `tauri-v1/package.json`, `tauri-v1/index.html`, `tauri-v1/src/`, `tauri-v1/tsconfig.json`, `tauri-v1/vite.config.ts`, optional Bun config
**Depends On**: TASK-001
**Parallelizable**: Yes, with TASK-003 and TASK-006 only

**Deliverables**:
- Implement minimal Bun/Vite/TypeScript frontend scaffold using chilla's Tauri dev-server shape.
- Include `@ign-var:PROJECT_NAME={current_dir}@`, `VERSION`, `DESCRIPTION`, `REPOSITORY`, `HOMEPAGE`, `AUTHOR_NAME`, `AUTHOR_EMAIL`, and `HAS_AUTHOR:bool` where appropriate.
- Keep dependencies minimal: Tauri API, Tauri CLI, TypeScript, Vite, and Bun type support as needed.
- Keep scripts predictable for development, build, preview, typecheck, test or check, and Tauri CLI access.

### TASK-003: Add Tauri/Rust Scaffold

**Status**: Completed
**Write Scope**: `tauri-v1/Cargo.toml`, `tauri-v1/src-tauri/`, `tauri-v1/rust-toolchain.toml`
**Depends On**: TASK-001
**Parallelizable**: Yes, with TASK-002 and TASK-006 only

**Deliverables**:
- Create a minimal Tauri v2 backend under `src-tauri/` using chilla's structural layout.
- Add workspace/root Cargo metadata only if it is needed for repository conventions or command ergonomics.
- Use `RUST_CRATE_NAME`, `RUST_LIB_NAME`, `RUST_VERSION`, `EDITION:int`, `VERSION`, `DESCRIPTION`, `REPOSITORY`, `HOMEPAGE`, and author variables.
- Add `src-tauri/tauri.conf.json` with Tauri v2 schema, product name, version, identifier, dev URL `http://localhost:1420`, frontend dist `../dist`, and generic window settings.
- Add `src-tauri/capabilities/default.json`, `build.rs`, `src/lib.rs`, and `src/main.rs`.

### TASK-004: Add Development Tooling

**Status**: Completed
**Write Scope**: `tauri-v1/Taskfile.yml`, `tauri-v1/flake.nix`, `tauri-v1/.envrc`
**Depends On**: TASK-002, TASK-003
**Parallelizable**: No

**Deliverables**:
- Add Taskfile commands following existing names: `default`, `build`, `test`, `check`, `fmt`, `fmt-check`, `lint`, and `clean`.
- Add a Nix development shell with Bun, Rust tooling, Tauri build dependencies, and ign-friendly local setup.
- Prefer development-shell support over full reproducible Tauri package outputs.
- Keep command names compatible with frontend and Rust scaffold files.

### TASK-005: Refresh Ign Template Metadata and Syntax

**Status**: Completed
**Write Scope**: `tauri-v1/ign-template.json` and any template syntax corrections inside `tauri-v1/`
**Depends On**: TASK-002, TASK-003, TASK-004
**Parallelizable**: No

**Deliverables**:
- Run `ign template update tauri-v1`.
- Confirm collected variables include at least the accepted design variable set.
- Confirm `HAS_AUTHOR` is typed bool and is the only conditional driver.
- Confirm defaults are literal and do not contain nested ign directives.
- Review `tauri-v1/ign-template.json` diff for expected variables and hash only.

### TASK-006: Update Repository README

**Status**: Completed
**Write Scope**: `README.md`
**Depends On**: TASK-001
**Parallelizable**: Yes, with TASK-002 and TASK-003 only

**Deliverables**:
- Add `tauri-v1` to "Available Templates".
- Add usage examples for GitHub checkout without output directory, with output directory, and dry-run preview.
- Keep existing listed templates visible.
- Avoid broad unrelated README cleanup.

### TASK-007: Final Verification and Handoff

**Status**: Completed
**Write Scope**: implementation plan progress log only, unless verification reveals required fixes
**Depends On**: TASK-005, TASK-006
**Parallelizable**: No

**Deliverables**:
- Run `ign template check tauri-v1`.
- Run `git diff -- tauri-v1 README.md design-docs impl-plans`.
- Run `git status --short`.
- Record validation commands, outcomes, any unresolved TODOs, and final changed files for the workflow handoff.

## Dependencies

| Task | Depends On | Reason |
|------|------------|--------|
| TASK-001 | None | Establishes the template root and metadata target. |
| TASK-002 | TASK-001 | Frontend files belong inside the new template root. |
| TASK-003 | TASK-001 | Tauri/Rust files belong inside the new template root. |
| TASK-004 | TASK-002, TASK-003 | Tooling commands must align with created frontend and Rust project shape. |
| TASK-005 | TASK-002, TASK-003, TASK-004 | Ign metadata must be refreshed after all template file edits. |
| TASK-006 | TASK-001 | README can document the template once the root exists. |
| TASK-007 | TASK-005, TASK-006 | Final verification needs updated template metadata and docs. |

## Parallelizable Tasks

- TASK-002, TASK-003, and TASK-006 may run in parallel after TASK-001 because their write scopes are disjoint.
- TASK-004 must run after TASK-002 and TASK-003 because it coordinates commands across both scaffolds.
- TASK-005 and TASK-007 must remain serial because they validate the combined template.

## Verification Plan

Required implementation commands:

- `ign template update tauri-v1`
- `ign template check tauri-v1`
- `git diff -- tauri-v1 README.md design-docs impl-plans`
- `git status --short`

Recommended generated-project smoke checks after ign validation:

- `ign checkout ./tauri-v1 "$TMPDIR/ign-tauri-v1-smoke" --force`
- `cd "$TMPDIR/ign-tauri-v1-smoke" && task check`

If the environment lacks platform GUI dependencies for a full Tauri build, record the exact skipped command and reason. Do not skip `ign template update tauri-v1` or `ign template check tauri-v1`.

## Completion Criteria

- [x] `tauri-v1/` exists and follows ign-template conventions.
- [x] Template variables match the accepted design and are collected by `ign template update tauri-v1`.
- [x] `HAS_AUTHOR` is a bool conditional; string variables are not used in ign conditionals.
- [x] `README.md` lists `tauri-v1` and includes checkout and dry-run examples.
- [x] `ign template update tauri-v1` completes successfully.
- [x] `ign template check tauri-v1` completes successfully.
- [x] `tauri-v1/ign-template.json` hash and variables are reviewed as expected.
- [x] Diff review confirms chilla product-specific features were not copied.
- [x] Progress log records implementation outcomes and unresolved TODOs.

## Progress Log Expectations

After each implementation session or task completion:

- Update this plan's task status.
- Update completion criteria checkboxes when verified.
- Add a dated Progress Log entry with completed tasks, in-progress tasks, blockers, verification commands run, and notes.
- If an ign command fails unexpectedly, log the command, expected behavior, actual behavior, and output.

## Progress Log

### Session: 2026-06-04

**Tasks Completed**: Plan created after accepted Step 3 design review.
**Tasks In Progress**: None.
**Blockers**: None.
**Verification Commands Run**:
- `jq '.' "$RIEL_MAILBOX_DIR/inbox/input.json"`
- `sed -n '1,260p' design-docs/specs/design-tauri-v1-template.md`
- `sed -n '1,220p' .agents/skills/template-editing/SKILL.md`
- `sed -n '1,260p' README.md`
- `sed -n '1,220p' bun-ts-v1/ign-template.json`
- `sed -n '1,220p' rust-v1/ign-template.json`
- `sed -n '1,240p' ../chilla/package.json`
- `sed -n '1,240p' ../chilla/src-tauri/Cargo.toml`
- `sed -n '1,260p' ../chilla/src-tauri/tauri.conf.json`
- `sed -n '1,220p' ../chilla/vite.config.ts`

**Notes**: Step 4 is planning-only. No template implementation files were edited.

### Session: 2026-06-04 Implementation

**Tasks Completed**: TASK-001 through TASK-007.
**Tasks In Progress**: None.
**Blockers**: None.
**Verification Commands Run**:
- `ign template update tauri-v1`
- `ign template check tauri-v1`
- Render smoke test for `HAS_AUTHOR=false` and `HAS_AUTHOR=true`, with generated JSON parsing for `package.json`, `src-tauri/tauri.conf.json`, `src-tauri/capabilities/default.json`, and `tsconfig.json`
- `bunx prettier --check "$TMPDIR/tauri-v1-render-no-author/src/**/*.{ts,css}" "$TMPDIR/tauri-v1-render-no-author/vite.config.ts"`
- `nix develop --command bash -lc 'command -v cargo && CARGO_TERM_QUIET=true cargo fmt --manifest-path "$TMPDIR/tauri-v1-render-no-author/src-tauri/Cargo.toml" -- --check'`
- `bun install && bun run typecheck`
- `nix develop --command bash -lc 'CARGO_TERM_QUIET=true cargo fmt --manifest-path src-tauri/Cargo.toml -- --check && CARGO_TERM_QUIET=true cargo check --manifest-path src-tauri/Cargo.toml'`

**Notes**: A direct `ign checkout` smoke test could not be completed because the prompt library did not progress correctly under the available PTY. A rendered-project verification path was used after `ign template check` passed. The initial Rust 1.83 default was raised to chilla's Rust 1.92.0 because current Tauri dependency resolution pulled a transitive crate requiring newer Cargo/Rust 2024 support. A generated RGBA placeholder icon was added because Tauri's compile-time context generation requires `src-tauri/icons/icon.png`.
