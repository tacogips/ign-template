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

### Deliverable 1: internal/path/to/file.go

**Purpose**: What this file/module does

**Exports**:

| Name | Type | Purpose | Called By |
|------|------|---------|-----------|
| `FunctionName` | func | What it does | Package that calls it |
| `InterfaceName` | interface | What it represents | Packages that use it |
| `StructName` | struct | What it provides | Packages that instantiate it |

**Function Signatures**:

```
FunctionName(param1 Type1, param2 Type2) (ReturnType, error)
  Purpose: What this function does
  Called by: Package/function that calls this
```

**Interface Definition**:

```
InterfaceName
  Purpose: What this interface represents
  Methods:
    - MethodName(params) (returns) - description
  Implemented by: Types that implement this interface
```

**Struct Definition**:

```
StructName
  Purpose: What this struct represents
  Fields:
    - FieldName Type - description (exported fields only)
  Used by: Packages that use this struct
```

**Dependencies**:
- `internal/other/module.go` - What it provides

**Dependents**:
- `internal/consumer/module.go` - How it uses this

---

### Deliverable 2: internal/path/to/another.go

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
- [ ] go build passes
- [ ] go test passes

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
- [ ] go build passes without errors
- [ ] go vet passes without warnings
- [ ] Code follows project coding standards
- [ ] Documentation updated (if applicable)

### Verification Steps

1. Run `go build ./...`
2. Run `go test ./...`
3. Run `go vet ./...`
4. Review implementation against design document

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
