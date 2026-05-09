---
name: template-editing
description: Edit ign templates safely. Use when changing files inside template directories such as bun-ts-v1, go-v1, rust-v1, python-v1, or general-v1, especially when template variables or generated template content may change.
---

# Template Editing

## Instructions

When modifying an ign template directory:

1. Identify the template root before editing. Template roots contain `ign-template.json`.
2. Make the requested edits inside the template root.
3. Run `ign template update <template-root>` after any template file change so `ign-template.json` variables and hash are refreshed.
4. Run `ign template check <template-root>` after the update.
5. Review the diff and confirm `ign-template.json` changed only as expected.
6. Report the update and validation results to the user.

## Notes

- Do not hand-edit the `hash` field in `ign-template.json`; let `ign template update` write it.
- If multiple template roots are changed, run `ign template update` and `ign template check` once for each changed template root.
- If `ign template update` fails because of an ign bug or unexpected behavior, do not silently work around it. Report the command, expected behavior, actual behavior, and error output so an issue can be filed for `https://github.com/tacogips/ign/issues`.
