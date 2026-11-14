# AGENTS.md

## Language

Always think and respond in English, regardless of the user's language.
Do not use emojis.

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

## Project Overview

This is a SwiftUI iOS app project generated from the `ios-app-v1` ign template.
It uses SwiftPM for modular app code and an Xcode project wrapper for iPhone/iPad
builds, simulator checks, archives, and App Store/TestFlight export.

## Development Environment

- Language: Swift
- UI framework: SwiftUI
- Package manager: Swift Package Manager
- App project: Xcode iOS app target
- Build runner: mise
- Environment manager: mise

## Commands

```bash
mise run build
mise run test
mise run build:app
mise run smoke:simulator-app
mise run archive:ios-app
mise run archive:ios-app-signed
mise run export:ios-app
mise run lint
```

## Coding Standards

- Follow standard Swift conventions and idioms.
- Use Swift concurrency deliberately; keep UI state on the main actor.
- Keep app feature code in `Sources/@ign-var:IOS_FEATURE_TARGET=AppFeature@`.
- Keep the SwiftUI app entry point in `Sources/@ign-var:IOS_APP_TARGET=App@`.
- Add focused tests under `Tests/@ign-var:IOS_FEATURE_TARGET=AppFeature@Tests`.
- Keep functions small and avoid speculative abstractions.

## Release Scope

This project intentionally has no macOS release or Homebrew release workflow.
Do not add Homebrew formula/cask packaging, Mac release scripts, or Mac
distribution artifacts unless the project scope explicitly changes.

The supported distribution path is iOS App Store/TestFlight export through the
iOS archive/export tasks.
