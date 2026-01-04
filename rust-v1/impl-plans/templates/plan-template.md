# <Feature Name> Implementation Plan

**Status**: Planning | Ready | In Progress | Completed
**Design Reference**: design-docs/specs/<file>.md#<section>
**Created**: YYYY-MM-DD
**Last Updated**: YYYY-MM-DD

---

## Design Document Reference

**Source**: [Link to design document section]

### Summary

Brief description of the feature being implemented from the design document.

### Scope

**Included**:
- What is being implemented

**Excluded**:
- What is NOT part of this implementation

---

## Implementation Overview

### Approach

High-level description of the implementation approach.

### Key Decisions

- Decision 1: Rationale
- Decision 2: Rationale

### Dependencies

| Dependency | Type | Status |
|------------|------|--------|
| Other feature/system | Required/Optional | Available/Pending |

---

## Deliverables

### Deliverable 1: src/path/to/module.rs

**Purpose**: What this file/module does

**Exports**:

| Name | Type | Purpose | Used By |
|------|------|---------|---------|
| `function_name` | fn | What it does | Module that calls it |
| `TraitName` | trait | What it represents | Modules that implement/use it |
| `StructName` | struct | What it provides | Modules that use it |

**Function Signatures**:

```
fn function_name(param1: Type1, param2: Type2) -> Result<ReturnType, Error>
  Purpose: What this function does
  Called by: Module/function that calls this
```

**Trait Definition**:

```
trait TraitName
  Purpose: What this trait represents
  Methods:
    - fn method_name(&self, params) -> ReturnType - description
  Implemented by: Types that implement this trait
```

**Struct Definition**:

```
struct StructName
  Purpose: What this struct represents
  Fields:
    - field_name: Type - description (pub fields only)
  Used by: Modules that use this struct
```

**Dependencies**:
- `src/other/module.rs` - What it provides

**Dependents**:
- `src/consumer/module.rs` - How it uses this

---

### Deliverable 2: src/path/to/another.rs

(Same structure as Deliverable 1)

---

## Subtasks

### TASK-001: <Task Name>

**Status**: Not Started | In Progress | Completed
**Parallelizable**: Yes | No (depends on TASK-XXX)
**Deliverables**: List of deliverable files
**Estimated Effort**: Small | Medium | Large

**Description**:
What needs to be done in this task.

**Completion Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Unit tests written and passing
- [ ] cargo build passes
- [ ] cargo test passes
- [ ] cargo clippy passes

---

### TASK-002: <Task Name>

**Status**: Not Started
**Parallelizable**: No (depends on TASK-001)
**Deliverables**: List of deliverable files
**Estimated Effort**: Medium

**Description**:
What needs to be done in this task.

**Completion Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2

---

## Task Dependency Graph

```
TASK-001 (Core Types)
    |
    v
TASK-002 (Parser) -----> TASK-004 (Integration)
    |                         ^
    v                         |
TASK-003 (Renderer) ----------+
```

(Use ASCII art or describe dependencies textually)

---

## Completion Criteria

### Required for Completion

- [ ] All subtasks marked as Completed
- [ ] All unit tests passing
- [ ] Integration tests passing (if applicable)
- [ ] cargo build passes without errors
- [ ] cargo clippy passes without warnings
- [ ] cargo fmt --check passes
- [ ] Code follows project coding standards
- [ ] Documentation updated (if applicable)

### Verification Steps

1. Run `cargo build`
2. Run `cargo test`
3. Run `cargo clippy`
4. Run `cargo fmt --check`
5. Review implementation against design document

---

## Progress Log

### Session: YYYY-MM-DD HH:MM

**Author**: (session identifier)
**Duration**: Xh

**Tasks Worked On**:
- TASK-001: Status update
- TASK-002: Status update

**Completed This Session**:
- Item 1
- Item 2

**Blockers**:
- None | Description of blocker

**Decisions Made**:
- Decision: Rationale

**Notes**:
- Any relevant observations

---

## Notes

### Open Questions

- Question 1?
- Question 2?

### Technical Debt

- Items to address later

### Future Enhancements

- Potential improvements outside current scope
