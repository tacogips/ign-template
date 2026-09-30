---
name: coding-policy
description: Use when writing, reviewing, or refactoring source code or scripts in this general workspace. Provides file-size and modularity rules that apply across languages.
allowed-tools: Read, Grep, Glob
---

# Coding Policy

This skill defines general source-code maintainability rules for this workspace.

## Source File Size

- **Hard limit**: No source code, script, or test file should stay above **1000 lines**. If a file is at or past that size, **split it** in the same change set or as a focused follow-up.
- **How to split**: Prefer cohesive boundaries such as feature, layer, adapter, parser, CLI, fixture, or test modules. Preserve stable public entry points with thin facade files when existing callers depend on a path.
- **Agents**: When editing or reviewing code, if a touched file is **1000+ lines**, treat splitting as **in scope** for the task unless the user explicitly excludes it.

## Modularity

- Keep files focused on one responsibility.
- Avoid using one catch-all utilities file as a dumping ground.
- Prefer explicit names that reveal the purpose of the extracted module.
