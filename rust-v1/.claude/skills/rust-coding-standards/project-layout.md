# Project Layout Conventions

Modern Rust project structure emphasizing clarity, maintainability, and idiomatic organization.

## Single Crate Layout

### Binary Application

```
project/
  src/
    main.rs           # Entry point, minimal code
    lib.rs            # Library root (optional, for integration tests)
    cli.rs            # CLI argument parsing
    config.rs         # Configuration types and loading
    error.rs          # Error types
    domain/           # Core business logic
      mod.rs
      user.rs
      order.rs
    service/          # Application services
      mod.rs
      user_service.rs
    repository/       # Data access
      mod.rs
      user_repo.rs
    api/              # HTTP/gRPC handlers (if applicable)
      mod.rs
      routes.rs
      handlers.rs
  tests/              # Integration tests
    common/
      mod.rs          # Shared test utilities
    api_tests.rs
  benches/            # Benchmarks
    benchmark.rs
  Cargo.toml
  Cargo.lock
```

### Library Crate

```
project/
  src/
    lib.rs            # Public API, re-exports
    parser/           # Feature module
      mod.rs          # Module root with public exports
      lexer.rs        # Implementation detail
      ast.rs
      error.rs
    formatter/
      mod.rs
      config.rs
      output.rs
  examples/           # Example usage
    basic.rs
    advanced.rs
  tests/              # Integration tests
    parser_tests.rs
  Cargo.toml
```

## Cargo Workspace Layout

For larger projects with multiple crates:

```
workspace/
  Cargo.toml          # Workspace manifest (workspace = { members = [...] })
  crates/
    core/             # Core domain types, no external dependencies
      src/
        lib.rs
      Cargo.toml
    parser/           # Parser library
      src/
        lib.rs
      Cargo.toml
    cli/              # CLI binary
      src/
        main.rs
      Cargo.toml
    server/           # Web server binary
      src/
        main.rs
      Cargo.toml
  tests/              # Workspace-level integration tests
  docs/               # Documentation
```

### Workspace Cargo.toml

```toml
[workspace]
resolver = "2"
members = [
    "crates/core",
    "crates/parser",
    "crates/cli",
    "crates/server",
]

[workspace.package]
version = "0.1.0"
edition = "2021"
license = "MIT"
authors = ["Your Name <you@example.com>"]

[workspace.dependencies]
# Shared dependencies with versions
tokio = { version = "1.0", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
thiserror = "1.0"
anyhow = "1.0"
tracing = "0.1"

# Internal crates
core = { path = "crates/core" }
parser = { path = "crates/parser" }
```

### Member Crate Cargo.toml

```toml
[package]
name = "cli"
version.workspace = true
edition.workspace = true

[dependencies]
core.workspace = true
parser.workspace = true
tokio.workspace = true
anyhow.workspace = true
clap = { version = "4.0", features = ["derive"] }
```

## Module Organization

### mod.rs Pattern

```rust
// src/domain/mod.rs
mod user;
mod order;
mod product;

// Public re-exports
pub use user::{User, UserId};
pub use order::{Order, OrderId, OrderStatus};
pub use product::{Product, ProductId};

// Keep private
// use product::internal_helper;
```

### Inline Module Pattern (Rust 2018+)

```
src/
  domain.rs           # Contains `pub mod user;` etc.
  domain/
    user.rs
    order.rs
```

```rust
// src/domain.rs
pub mod user;
pub mod order;

pub use user::{User, UserId};
pub use order::{Order, OrderId};
```

### Visibility Rules

```rust
// In src/domain/user.rs

/// Public to entire crate and external users
pub struct User { ... }

/// Public only within this crate
pub(crate) struct UserInternal { ... }

/// Public only within parent module
pub(super) fn helper() { ... }

/// Private to this module (default)
struct UserImpl { ... }
```

## Main Entry Point

Keep `main.rs` minimal - delegate to library:

```rust
// src/main.rs
use anyhow::Result;

fn main() -> Result<()> {
    // Initialize logging
    tracing_subscriber::init();

    // Parse CLI args
    let args = myapp::cli::Args::parse();

    // Run application
    myapp::run(args)
}
```

```rust
// src/lib.rs
pub mod cli;
mod config;
mod service;
mod domain;

use anyhow::Result;

pub fn run(args: cli::Args) -> Result<()> {
    let config = config::load(&args.config_path)?;
    let service = service::AppService::new(config)?;
    service.start()
}
```

## Testing Organization

### Unit Tests (Same File)

```rust
// src/domain/user.rs

pub struct User {
    id: UserId,
    name: String,
}

impl User {
    pub fn new(name: impl Into<String>) -> Self {
        Self {
            id: UserId::generate(),
            name: name.into(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_new_user() {
        let user = User::new("Alice");
        assert_eq!(user.name, "Alice");
    }
}
```

### Integration Tests

```rust
// tests/api_tests.rs
use myapp::api::create_app;

#[tokio::test]
async fn test_create_user() {
    let app = create_app().await;
    let response = app.post("/users").json(&json!({"name": "Alice"})).await;
    assert_eq!(response.status(), 201);
}
```

### Test Utilities

```rust
// tests/common/mod.rs
use myapp::config::Config;

pub fn test_config() -> Config {
    Config {
        database_url: "postgres://test@localhost/test".into(),
        ..Default::default()
    }
}

pub async fn setup_test_db() -> TestDb {
    // ...
}
```

## Feature Flags

```toml
# Cargo.toml
[features]
default = ["json"]
json = ["serde_json"]
postgres = ["sqlx/postgres"]
full = ["json", "postgres"]
```

```rust
// src/lib.rs
#[cfg(feature = "json")]
pub mod json_support;

#[cfg(feature = "postgres")]
pub mod postgres_repo;
```

## Documentation

```rust
// src/lib.rs

//! # MyApp
//!
//! `myapp` is a library for doing amazing things.
//!
//! ## Quick Start
//!
//! ```rust
//! use myapp::Config;
//!
//! let config = Config::default();
//! myapp::run(config)?;
//! ```

/// Configuration for the application.
///
/// # Examples
///
/// ```
/// use myapp::Config;
///
/// let config = Config::builder()
///     .port(8080)
///     .build()?;
/// ```
pub struct Config { ... }
```

## Anti-Patterns to Avoid

```
// BAD: Deep nesting
src/
  modules/
    core/
      domain/
        entities/
          user/
            types/
              user.rs   // 6 levels deep!

// GOOD: Flat structure
src/
  domain/
    user.rs
    order.rs
  service/
    user_service.rs

// BAD: Everything in lib.rs
src/
  lib.rs              // 2000 lines of code

// GOOD: Split into modules
src/
  lib.rs              // Re-exports only
  parser.rs
  formatter.rs
  error.rs

// BAD: Circular dependencies between modules
// user.rs imports order.rs, order.rs imports user.rs

// GOOD: Extract shared types to common module
// common.rs defines shared types
// user.rs and order.rs import from common.rs

// BAD: pub on everything
pub mod internal_impl;
pub fn private_helper();

// GOOD: Minimal public API
pub mod api;
mod internal_impl;
fn private_helper();
```

## Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Crates | snake_case | `my_parser` |
| Modules | snake_case | `user_service` |
| Types | PascalCase | `UserService` |
| Functions | snake_case | `get_user_by_id` |
| Constants | SCREAMING_SNAKE | `MAX_CONNECTIONS` |
| Type Parameters | Single uppercase | `T`, `E`, `K`, `V` |

## References

- [Cargo Book - Package Layout](https://doc.rust-lang.org/cargo/guide/project-layout.html)
- [Cargo Book - Workspaces](https://doc.rust-lang.org/cargo/reference/workspaces.html)
- [Rust API Guidelines - Organization](https://rust-lang.github.io/api-guidelines/predictability.html)
- [Rust Module System Explained](https://www.sheshbabu.com/posts/rust-module-system/)
