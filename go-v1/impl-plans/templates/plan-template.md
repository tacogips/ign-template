# <Feature Name> Implementation Plan

**Status**: Planning | Ready | In Progress | Completed
**Design Reference**: design-docs/<file>.md
**Created**: YYYY-MM-DD
**Last Updated**: YYYY-MM-DD

---

## Design Document Reference

**Source**: design-docs/<file>.md

### Summary

Brief description of the feature being implemented from the design document.

### Scope

**Included**:
- What is being implemented

**Excluded**:
- What is NOT part of this implementation

---

## Modules

### 1. Core Interfaces

#### internal/interfaces/example.go

**Status**: NOT_STARTED

```go
type Example interface {
    Process(ctx context.Context, input Input) (*Output, error)
    Validate(input Input) error
}

type ExampleConfig struct {
    Option1 string
    Option2 int
}
```

**Checklist**:
- [ ] Define Example interface
- [ ] Define ExampleConfig struct
- [ ] Export from interfaces package
- [ ] Unit tests

---

### 2. Implementation

#### internal/example/manager.go

**Status**: NOT_STARTED

```go
type Manager struct {
    config *ExampleConfig
    repo   Repository
}

func NewManager(config *ExampleConfig, repo Repository) *Manager

func (m *Manager) Create(ctx context.Context, opts CreateOptions) (*Example, error)
func (m *Manager) Get(ctx context.Context, id string) (*Example, error)
func (m *Manager) List(ctx context.Context, filter *Filter) ([]*Example, error)
func (m *Manager) Update(ctx context.Context, id string, updates Updates) (*Example, error)
func (m *Manager) Delete(ctx context.Context, id string) error
```

**Checklist**:
- [ ] Implement Manager struct
- [ ] Implement NewManager constructor
- [ ] Implement CRUD methods
- [ ] Unit tests
- [ ] Integration tests

---

## Module Status

| Module | File Path | Status | Tests |
|--------|-----------|--------|-------|
| Example interface | `internal/interfaces/example.go` | NOT_STARTED | - |
| Manager | `internal/example/manager.go` | NOT_STARTED | - |

---

## Dependencies

| Feature | Depends On | Status |
|---------|------------|--------|
| This feature | Foundation layer | Available |
| HTTP API | This feature | BLOCKED |

---

## Completion Criteria

- [ ] All modules implemented
- [ ] All unit tests passing
- [ ] All integration tests passing
- [ ] go build passes
- [ ] go vet passes
- [ ] Code follows project standards

---

## Progress Log

### Session: YYYY-MM-DD HH:MM

**Tasks Completed**: (list)
**Tasks In Progress**: (list)
**Blockers**: None
**Notes**: (any observations)
