---
description: Generate execution plan from design document
argument-hint: "<design-doc-path> [feature-name]"
---

## Generate Execution Plan Command

This command creates an execution plan from a design document.

### Current Context

- Working directory: !`pwd`
- Current branch: !`git branch --show-current`

### Arguments Received

$ARGUMENTS

## Instructions

Invoke the `impl-plan` subagent using the Task tool.

### Argument Parsing

Parse `$ARGUMENTS` to extract:

1. **Design Document Path** (required)
2. **Feature Name** (optional)

### Determine Output Path

Generate the output path based on feature name:

- If feature name is provided: `impl-plans/active/<feature-name>.md`
- Otherwise derive it from the design document path or section

### Invoke Subagent

```text
Task tool parameters:
  subagent_type: impl-plan
  prompt: |
    Design Document: <parsed-design-doc-path>
    Feature Scope: <parsed-or-derived-feature-scope>
    Output Path: <generated-output-path>
```

### After Subagent Completes

1. Report the created plan file path
2. Summarize the workstreams and parallelization opportunities
3. Suggest next steps

### Error Handling

If no arguments are provided, respond with:

```text
Usage: /impl-plan <design-doc-path> [feature-name]

Examples:
  /impl-plan design-docs/specs/architecture.md#source-review
  /impl-plan design-docs/specs/notes.md evidence-review
```
