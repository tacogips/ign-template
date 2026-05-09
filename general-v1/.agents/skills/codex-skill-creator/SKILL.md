---
name: codex-skill-creator
description: Use when creating or updating Codex-compatible skills. Provides structure, metadata, progressive disclosure rules, and guidance for scripts, references, and assets.
allowed-tools: Read, Write, Glob, Grep
---

# Codex Skill Creator

Use this skill when the user asks to create, update, or reorganize a Codex skill.

## Goal

Create a reusable skill that helps Codex perform a specific class of tasks with less repeated prompting and less context waste.

## Target Structure

Create the skill under `.agents/skills/<skill-name>/` unless the user explicitly requests a different location.

```text
.agents/skills/<skill-name>/
├── SKILL.md
├── references/
├── scripts/
└── assets/
```

## Required File

Every skill must have `SKILL.md` with YAML frontmatter:

```yaml
---
name: skill-name
description: Clear description of when this skill should be used.
allowed-tools: Read, Write, Glob, Grep
---
```

Rules:
- `name` should be short and stable
- `description` must state what the skill does and when it should trigger
- Only list tools the skill genuinely needs

## Writing Guidelines

- Keep `SKILL.md` concise and procedural
- Assume Codex already knows general engineering concepts
- Put only the core workflow in `SKILL.md`
- Move large examples or detailed references into `references/`
- Add `scripts/` only when deterministic execution matters
- Add `assets/` only when files must be copied or reused in outputs

## Progressive Disclosure

Use this structure:

1. `SKILL.md` for the core workflow
2. `references/` for detailed docs loaded on demand
3. `scripts/` for deterministic repeated steps

`SKILL.md` should point directly to any optional files it expects the agent to use.

## Avoid

- Large tutorials in `SKILL.md`
- Redundant README files
- Copying long source material into the skill
- Adding scripts that are never referenced
- Overly broad descriptions such as "use for coding"

## Update Workflow

When updating an existing skill:

1. Read the current `SKILL.md`
2. Preserve the existing trigger intent unless the user asks to change it
3. Remove stale instructions and broken references
4. Keep file names stable when other instructions already point to them
