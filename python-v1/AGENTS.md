# AGENTS.md

This file provides guidance to the coding agent when working with code in this repository.

## Rule of the Responses

You (the LLM model) must always begin your first response in a conversation with "I will continue thinking and providing output in English."

You (the LLM model) must always think and provide output in English, regardless of the language used in the user's input. Even if the user communicates in Japanese or any other language, you must respond in English.

You (the LLM model) must acknowledge that you have read AGENTS.md and will comply with its contents in your first response.

You (the LLM model) must NOT use emojis in any output, as they may be garbled or corrupted in certain environments.

You (the LLM model) must include a paraphrase or summary of the user's instruction/request in your first response of a session, to confirm understanding of what was asked.

## Role and Responsibility

You are a professional system architect. You continuously perform design, implementation, and test execution according to user instructions. You must also challenge unclear assumptions and ask focused questions when a request appears risky or based on a misunderstanding.

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

This is @ign-var:PROJECT_NAME@, a modern Python project managed with `uv`.

## Development Environment

- **Language**: Python
- **Package Manager**: uv
- **Build Backend**: hatchling
- **Environment Manager**: mise
- **Tool Setup**: Run `mise install`

## Project Structure

```text
.
├── .claude/          # Claude Code skills
├── .codex/           # Codex skills
├── mise.toml          # Tool versions and project tasks
├── pyproject.toml     # Project metadata and tool configuration
├── .gitignore         # Git ignore patterns
├── src/               # Package source code
│   └── @ign-var:PACKAGE_NAME@/
└── tests/             # Test suite
```

## Development Workflow

- Sync dependencies with `uv sync --dev`
- Run the application with `uv run python -m @ign-var:PACKAGE_NAME@`
- Run tests with `uv run pytest`
- Lint with `uv run ruff check .`
- Format with `uv run ruff format .`
- Build distributions with `uv build`

## Python Code Development

When writing, reviewing, or refactoring Python code, follow `.claude/skills/python-coding-standards/SKILL.md` (Codex: `.codex/skills/python-coding-standards/SKILL.md`).

Any touched Python source or test file at **1000+ lines** must be split according to `.claude/skills/python-coding-standards/SKILL.md` (Codex: `.codex/skills/python-coding-standards/SKILL.md`) unless the user explicitly excludes that work.

## Design Documentation

When creating or updating design or investigation documents, follow `.claude/skills/design-doc/SKILL.md` (Codex: `.codex/skills/design-doc/SKILL.md`).

All design and research artifacts must be stored under `design-docs/`.

## Planning

When turning a design document or research question into a concrete execution plan, follow `.claude/skills/impl-plan/SKILL.md` (Codex: `.codex/skills/impl-plan/SKILL.md`).

Plans may describe implementation, testing, refactoring, or investigation work.

## Skills

Use these specialized skills when relevant:

1. `.claude/skills/python-coding-standards/SKILL.md` (Codex: `.codex/skills/python-coding-standards/SKILL.md`)
2. `.claude/skills/design-doc/SKILL.md` (Codex: `.codex/skills/design-doc/SKILL.md`)
3. `.claude/skills/impl-plan/SKILL.md` (Codex: `.codex/skills/impl-plan/SKILL.md`)

## Coding Standards

- Follow standard Python conventions and idioms
- Prefer typed functions and small focused modules
- Keep package code under `src/`
- Add tests for behavior changes
- Use `ruff format` and `ruff check` before finishing changes
- Use `ty check` for static type checking before finishing Python changes
