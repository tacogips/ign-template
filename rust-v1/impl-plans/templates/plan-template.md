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

### 1. Core Traits

#### src/interfaces/example.rs

**Status**: NOT_STARTED

```rust
pub trait Example: Send + Sync {
    fn process(&self, ctx: &Context, input: Input) -> Result<Output>;
    fn validate(&self, input: &Input) -> Result<()>;
}

#[derive(Debug, Clone)]
pub struct ExampleConfig {
    pub option1: String,
    pub option2: Option<i32>,
}
```

**Checklist**:
- [ ] Define Example trait
- [ ] Define ExampleConfig struct
- [ ] Export from lib.rs
- [ ] Unit tests

---

### 2. Implementation

#### src/example/manager.rs

**Status**: NOT_STARTED

```rust
pub struct Manager {
    config: ExampleConfig,
    repo: Box<dyn Repository>,
}

impl Manager {
    pub fn new(config: ExampleConfig, repo: Box<dyn Repository>) -> Self;

    pub async fn create(&self, ctx: &Context, opts: CreateOptions) -> Result<Example>;
    pub async fn get(&self, ctx: &Context, id: &str) -> Result<Option<Example>>;
    pub async fn list(&self, ctx: &Context, filter: &Filter) -> Result<Vec<Example>>;
    pub async fn update(&self, ctx: &Context, id: &str, updates: Updates) -> Result<Example>;
    pub async fn delete(&self, ctx: &Context, id: &str) -> Result<()>;
}
```

**Checklist**:
- [ ] Implement Manager struct
- [ ] Implement new constructor
- [ ] Implement CRUD methods
- [ ] Unit tests
- [ ] Integration tests

---

## Module Status

| Module | File Path | Status | Tests |
|--------|-----------|--------|-------|
| Example trait | `src/interfaces/example.rs` | NOT_STARTED | - |
| Manager | `src/example/manager.rs` | NOT_STARTED | - |

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
- [ ] cargo build passes
- [ ] cargo clippy passes
- [ ] cargo fmt --check passes
- [ ] Code follows project standards

---

## Progress Log

### Session: YYYY-MM-DD HH:MM

**Tasks Completed**: (list)
**Tasks In Progress**: (list)
**Blockers**: None
**Notes**: (any observations)
