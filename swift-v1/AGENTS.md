# AGENTS.md

This file provides guidance to coding agents when working with this repository.

## Rule of the Responses

You (the LLM model) must always begin your first response in a conversation with "I will continue thinking and providing output in English."

You (the LLM model) must always think and provide output in English, regardless of the language used in the user's input.

You (the LLM model) must acknowledge that you have read AGENTS.md and will comply with its contents in your first response.

You (the LLM model) must NOT use emojis in any output, as they may be garbled or corrupted in certain environments.

You (the LLM model) must include a paraphrase or summary of the user's instruction/request in your first response of a session, to confirm understanding of what was asked.

## Project Overview

This is `@ign-var:PROJECT_NAME={current_dir}@`, a Swift Package Manager project with mise-managed tools and tasks, Homebrew formula packaging, and optional signed Homebrew Cask packaging.

## Development Environment

- Language: Swift
- Package manager: Swift Package Manager
- Build automation: mise
- Environment manager: mise
- Tool setup: `mise install`

## Common Commands

```bash
mise run build
mise run test
mise run lint
swift run @ign-var:EXECUTABLE_NAME={current_dir}@ --help
```

## Swift Code Development

When implementing, refactoring, reviewing, or maintaining Swift code, use the Swift coding skill at `.codex/skills/swift-coding-agent/SKILL.md`.

Important defaults:

- Inspect `Package.swift`, nearby source, tests, and existing conventions before editing.
- Prefer the current SwiftPM target boundaries over adding new modules.
- Keep Swift files under 1000 lines. Split long files by meaningful responsibility.
- Run `swiftlint` after Swift edits when available.
- Run the narrowest relevant `swift test` or `swift build` command, then broaden when shared behavior changed.

## Release Workflows

Use `.claude/skills/homebrew-release/SKILL.md` (Codex: `.codex/skills/homebrew-release/SKILL.md`) for Homebrew formula archives and tap formula rendering.

Use `.claude/skills/macos-cask-release/SKILL.md` (Codex: `.codex/skills/macos-cask-release/SKILL.md`) for signed and notarized Cask DMGs, GitHub release upload, and tap Cask rendering.

Use `.claude/skills/apple-notarization-setup/SKILL.md` (Codex: `.codex/skills/apple-notarization-setup/SKILL.md`) when setting up or checking Apple Developer ID credentials. Never print, commit, or summarize secret values.

## Git Email Privacy Gate

Before any commit, annotated tag, or push (including a release script that runs
Git), verify that the operation will not disclose a private email address.
Addresses on the domain matched by `tacogips[.]me`, including plus-address aliases,
are private. Honor any additional private addresses/domains identified by the
user. Do not copy the actual private addresses into tracked policy, examples,
tests, logs, commit messages, or reports. Third-party copyright notices and dummy
test addresses are not prohibited solely because they are email addresses.

1. **Before committing:** inspect the effective identities with `git var
   GIT_AUTHOR_IDENT` and `git var GIT_COMMITTER_IDENT`, including environment and
   command-line overrides. Use an empty email or the owner's verified GitHub
   noreply identity, never a private address. Keep configuration changes local to
   the repository. Check inherited authors when amending, rebasing, or cherry-picking.
2. **After final staging:** scan the actual staged snapshot, including newly added
   files, and the exact final commit message/trailers. For the owner's domain, use
   `private_email_pattern='[[:alnum:]._%+-]+@tacogips[.]me'` and
   `git grep --cached -I -l -i -E "$private_email_pattern" --` to locate files
   without printing matching values. Also review URL-encoded or obfuscated email
   spellings. A scanner error is not a passing result; inspect non-text assets
   separately when they could contain contact information.
3. **After creating a commit/tag:** inspect raw objects with `git cat-file commit
   <commit>` or `git cat-file tag <tag>`. Verify author, committer, tagger,
   messages, and trailers; `.mailmap` or a GitHub profile display does not remove
   an address from an object. Keep matching values out of user-facing output.
4. **Immediately before pushing:** resolve every intended branch/tag and the
   actual remote destination. Scan all outgoing commits and their file snapshots,
   messages, author/committer fields, and annotated-tag objects, including their
   ancestors that will become reachable at the destination. For a new branch or
   tag, check its reachable history rather than assuming no upstream means no
   history. Do not limit this check to HEAD, the latest diff, or `user.email`.
5. **Block on a match or incomplete check:** do not commit or push the offending
   material. Report only paths/object IDs and field names. Correct private data
   within the authorized scope, then rerun the gate. Do not rewrite published
   history, force-push, or remove third-party attribution without authorization.
   Report which refs/ranges were checked and whether the gate passed.

## Git Commit Policy

When a user asks to commit changes, automatically stage and commit the changes without requiring confirmation.

Do not add AI tool attribution or co-authorship information to commit messages.

Keep commits focused and describe:

1. Primary changes and intent
2. Key technical concepts
3. Files and code sections
4. Problem solving
5. Impact
6. Unresolved TODOs

## Design Documentation

Place design documents under `design-docs/`, implementation plans under `impl-plans/`, and user decisions/questions under `design-docs/user-qa/`.
