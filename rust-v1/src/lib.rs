//! @ign-var:PROJECT_NAME@ - @ign-var:DESCRIPTION@
//!
//! This crate provides the core functionality for the @ign-var:PROJECT_NAME@ project.

/// A placeholder function that returns a greeting message.
///
/// # Examples
///
/// ```
/// use @ign-var:PROJECT_NAME@::hello;
/// assert_eq!(hello(), "Hello from @ign-var:PROJECT_NAME@!");
/// ```
pub fn hello() -> &'static str {
    "Hello from @ign-var:PROJECT_NAME@!"
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hello() {
        assert_eq!(hello(), "Hello from @ign-var:PROJECT_NAME@!");
    }
}
