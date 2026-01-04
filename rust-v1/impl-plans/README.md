# Implementation Plans

This directory contains implementation plans that translate design documents into actionable implementation specifications.

## Purpose

Implementation plans bridge design documents (what to build) and actual code (how to build). They provide:
- Clear deliverables without code
- Trait and function specifications
- Dependency mapping for concurrent execution
- Progress tracking across sessions

## Directory Structure

```
impl-plans/
├── README.md              # This file
├── active/                # Currently active implementation plans
│   └── <feature>.md       # One file per feature being implemented
├── completed/             # Completed implementation plans (archive)
│   └── <feature>.md       # Completed plans for reference
└── templates/             # Plan templates
    └── plan-template.md   # Standard plan template
```

## Active Plans

| Plan | Status | Design Reference | Last Updated |
|------|--------|------------------|--------------|
| (No active plans yet) | - | - | - |

## Completed Plans

| Plan | Completed | Design Reference |
|------|-----------|------------------|
| (No completed plans yet) | - | - |

## Workflow

### Creating a New Plan

1. Use the `/gen-impl-plan` command with a design document reference
2. Or manually create a plan using `templates/plan-template.md`
3. Save to `active/<feature-name>.md`
4. Update this README with the new plan entry

### Working on a Plan

1. Read the active plan
2. Select a subtask to work on (consider parallelization)
3. Implement following the deliverable specifications
4. Update task status and progress log
5. Mark completion criteria as done

### Completing a Plan

1. Verify all completion criteria are met
2. Update status to "Completed"
3. Move file from `active/` to `completed/`
4. Update this README

## Guidelines

- Plans contain NO implementation code
- Plans specify traits, functions, and file structures
- Subtasks should be as independent as possible for parallel execution
- Always update progress log after each session
