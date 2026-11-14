# Implementation Plans

This directory contains execution plans that translate design documents into actionable work.

## Purpose

Execution plans bridge design documents and actual work. They provide:
- Clear deliverables without unnecessary detail
- Dependency mapping for concurrent execution
- Validation steps for each workstream
- Progress tracking across sessions

## Directory Structure

```text
impl-plans/
├── README.md
├── active/
├── completed/
└── templates/
```

## File Size Limits

Plan files should stay under 400 lines to keep them reviewable.

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

1. Use `/impl-plan` with a design document reference
2. Or create a plan from `templates/plan-template.md`
3. Save it to `active/<feature-name>.md`
4. Update this README with the new entry
5. Split large plans into focused files

### Working on a Plan

1. Read the active plan
2. Select a workstream
3. Execute the deliverables and validation steps
4. Update status and progress log
5. Mark completion criteria as done

### Completing a Plan

1. Verify all completion criteria are met
2. Update status to `Completed`
3. Move the file from `active/` to `completed/`
4. Update this README

## Guidelines

- Plans should focus on outcomes, dependencies, and validation
- Deliverables may be documents, scripts, experiments, or code
- Workstreams should be as independent as possible
- Always update the progress log after each session
