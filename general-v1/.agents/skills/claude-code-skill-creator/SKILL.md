---
name: claude-code-skill-creator
description: Use when creating or updating Claude Code compatible skills. Provides guidance for SKILL.md structure, frontmatter, project-local placement, and supporting references or scripts.
allowed-tools: Read, Write, Glob, Grep
---

# Claude Code Skill Creator

Use this skill when the user asks to create, update, or reorganize a Claude Code skill.

## Goal

Create a concise, project-local skill that Claude Code can discover and apply without forcing unnecessary context into every session.

## Target Location

Unless the user requests otherwise, place new skills under `.agents/skills/<skill-name>/`.

If the user explicitly wants a Claude Code native layout, mirror the same skill under `.claude/skills/<skill-name>/`.

## Required File

Each skill must include `SKILL.md` with frontmatter similar to:

```yaml
---
name: skill-name
description: Use when the user asks for ...
allowed-tools: Read, Write, Glob, Grep
argument-hint: [optional]
user-invocable: true
---
```

Rules:
- `name` should match the directory name
- `description` should clearly describe trigger conditions
- `allowed-tools` should be minimal
- `argument-hint` is optional
- `user-invocable` should be added only when direct invocation makes sense

## Skill Body

The body should cover:

1. When to apply the skill
2. The required workflow
3. Output location and file naming rules
4. Validation before finishing
5. Which files in `references/` or `scripts/` to use

Keep the body short and directive. Prefer checklists and short examples over long explanations.

## Supporting Files

Use optional subdirectories when needed:

```text
<skill-name>/
├── SKILL.md
├── references/
├── scripts/
└── assets/
```

Guidelines:
- `references/` for long or variant-specific documentation
- `scripts/` for repeatable helpers
- `assets/` for templates or static files reused in outputs

## Compatibility Notes

- Keep `SKILL.md` self-contained enough that the agent knows where to start
- Do not assume plugin infrastructure unless the user explicitly asks for a plugin
- Skills and plugins are different concerns

## Update Workflow

When updating an existing Claude Code skill:

1. Read the existing `SKILL.md`
2. Preserve compatible frontmatter keys unless there is a reason to change them
3. Remove stale references
4. Keep file names and locations stable when other docs already depend on them
