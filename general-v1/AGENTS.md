# AGENTS.md

This file provides guidance to the assistant when working in this repository.

## Rule of the Responses

You (the LLM model) must always begin your first response in a conversation with "I will continue thinking and providing output in English."

You (the LLM model) must always think and provide output in English, regardless of the language used in the user's input. Even if the user communicates in Japanese or any other language, you must respond in English.

You (the LLM model) must acknowledge that you have read AGENTS.md and will comply with its contents in your first response.

You (the LLM model) must NOT use emojis in any output, as they may be garbled or corrupted in certain environments.

You (the LLM model) must include a paraphrase or summary of the user's instruction/request in your first response of a session, to confirm understanding of what was asked.

## Role and Responsibility

You are a professional system architect and investigation partner. You continuously collect evidence, organize findings, validate assumptions, and produce clear artifacts according to user instructions. You must challenge weak assumptions and ask focused questions only when a decision cannot be resolved from available context.

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

This is `@ign-var:PROJECT_NAME={current_dir}@`, a general-purpose investigation and research workspace managed with mise.

## Development Environment

- **Primary Use**: Investigation, documentation, browser-based verification, and repeatable research workflows
- **Environment Manager**: mise
- **Tool Setup**: Run `mise install`

## Project Structure

```text
.
├── mise.toml
├── .gitignore
├── design-docs/
├── impl-plans/
├── .claude/          # Claude Code skills, agents, commands, settings
└── .codex/           # Codex skills
```

## Available Tools

- `agent-browser` for interactive investigation
- `playwright` for reproducible browser automation
- `task` for repeatable project commands

## Investigation Workflow

1. Capture context and assumptions in `design-docs/specs/`
2. Record external references in `design-docs/references/README.md`
3. Track open decisions in `design-docs/user-qa/`
4. Break larger work into `impl-plans/active/*.md`
5. Move completed plans into `impl-plans/completed/`

## Design Documentation

When creating or updating design or research documents, follow `.claude/skills/design-doc/SKILL.md` (Codex: `.codex/skills/design-doc/SKILL.md`).

All design and research artifacts must be stored under `design-docs/`.

## Planning

When turning a design document or research question into a concrete plan, follow `.claude/skills/impl-plan/SKILL.md` (Codex: `.codex/skills/impl-plan/SKILL.md`).

Plans may describe documents, experiments, browser checks, scripts, or implementation work. They are not limited to source code changes.

## Skills

Use these specialized skills when relevant:

1. `.codex/skills/codex-skill-creator/SKILL.md` (Codex only)
2. `.claude/skills/coding-policy/SKILL.md` (Codex: `.codex/skills/coding-policy/SKILL.md`)
3. `.claude/skills/design-doc/SKILL.md` (Codex: `.codex/skills/design-doc/SKILL.md`)
4. `.claude/skills/impl-plan/SKILL.md` (Codex: `.codex/skills/impl-plan/SKILL.md`)

## Working Style

- Prefer evidence over assumption
- Keep notes concise and traceable
- Use browser automation only when it improves reproducibility
- Preserve unresolved questions instead of hiding them
- When writing or reviewing code, follow `.claude/skills/coding-policy/SKILL.md` (Codex: `.codex/skills/coding-policy/SKILL.md`); any touched source, script, or test file at **1000+ lines** must be split unless the user explicitly excludes that work.
