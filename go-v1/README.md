# @ign-var:PROJECT_NAME@

@ign-var:DESCRIPTION=A Go project@

## Requirements

- Go @ign-var:GO_VERSION=1.23@ or later
@ign-if:USE_TASK@
- [Task](https://taskfile.dev/) (optional, for task automation)
@ign-endif@

## Getting Started

```bash
# Build
go build -o @ign-var:PROJECT_NAME@ ./cmd/@ign-var:PROJECT_NAME@

# Run
./@ign-var:PROJECT_NAME@

# Test
go test ./...
```

@ign-if:USE_TASK@
## Task Commands

```bash
task build    # Build the binary
task run      # Run the application
task test     # Run tests
task lint     # Run linter
task clean    # Clean build artifacts
```
@ign-endif@

## Project Structure

```
.
├── cmd/@ign-var:PROJECT_NAME@/   # Application entry point
├── internal/                      # Private application code
├── pkg/                           # Public library code
@ign-if:USE_TASK@
├── Taskfile.yml                   # Task automation
@ign-endif@
└── go.mod                         # Go module definition
```

## License

@ign-var:LICENSE=MIT@
