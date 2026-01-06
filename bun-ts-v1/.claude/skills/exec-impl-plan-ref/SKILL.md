---
name: exec-impl-plan-ref
description: Use when executing tasks from implementation plans. Provides task selection, parallel execution, progress tracking, and review cycle guidelines.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TaskOutput
---

# Implementation Execution Skill

This skill provides guidelines for executing implementation plans created by the `impl-plan` agent.

## When to Apply

Apply this skill when:
- Executing tasks from an implementation plan in `impl-plans/active/`
- Tracking progress during multi-session implementation work
- Coordinating concurrent execution of parallelizable subtasks
- Updating implementation plan status and progress logs

## Purpose

This skill bridges implementation plans (what to build) and actual code implementation. It provides:
- Task selection based on dependencies and parallelization
- Sequential execution via Claude subtasks (ONE task at a time)
- Progress tracking and plan updates
- Completion verification and plan finalization

---

## CRITICAL: Use PROGRESS.json to Prevent Context Overflow

**NEVER read all plan files at once.** This causes context overflow (>200K tokens).

Instead, use `impl-plans/PROGRESS.json` which contains:
- Phase status (COMPLETED, READY, BLOCKED)
- All task statuses across all plans (~2K tokens)
- Task dependencies

**Workflow**:
1. Read `PROGRESS.json` (~2K tokens) to find executable tasks
2. Read ONLY the specific plan file when executing a task (~10K tokens)
3. After execution, update BOTH the plan file AND `PROGRESS.json`

### PROGRESS.json Structure

```json
{
  "lastUpdated": "2026-01-06T16:00:00Z",
  "phases": {
    "1": { "status": "COMPLETED" },
    "2": { "status": "READY" },
    "3": { "status": "BLOCKED" },
    "4": { "status": "BLOCKED" }
  },
  "plans": {
    "plan-name": {
      "phase": 2,
      "status": "Ready",
      "tasks": {
        "TASK-001": { "status": "Not Started", "parallelizable": true, "deps": [] },
        "TASK-002": { "status": "Completed", "parallelizable": true, "deps": [] },
        "TASK-003": { "status": "Not Started", "parallelizable": false, "deps": ["TASK-001"] }
      }
    }
  }
}
```

### Dependency Format

- **Same-plan dependency**: `"deps": ["TASK-001"]`
- **Cross-plan dependency**: `"deps": ["other-plan:TASK-001"]`

---

## Execution Modes

Two execution modes are available:

### Auto Mode (`impl-exec-auto`)

Automatically selects and executes tasks. **Executes tasks sequentially (ONE at a time)** to prevent LLM errors.

**Cross-Plan Mode** (no argument - recommended):
```bash
/impl-exec-auto
```
Analyzes PROGRESS.json and executes all eligible tasks across plans.

**Single-Plan Mode** (with argument):
```bash
/impl-exec-auto foundation-and-core
```
Focuses on one specific plan only.

Use this mode when:
- Starting implementation (cross-plan mode)
- Continuing work after completing some tasks
- Running iteratively

The auto mode:
1. Reads `impl-plans/PROGRESS.json` (NOT all plan files!)
2. Identifies executable tasks from PROGRESS.json
3. For each executable task:
   - Read the specific plan file (only when needed)
   - Execute ts-coding agent
   - Run check-and-test
   - Run review cycle
   - Update both plan file AND PROGRESS.json
4. Reports progress and newly unblocked tasks

**CRITICAL**: Tasks are executed sequentially (one at a time) to prevent LLM errors.

### Specific Mode (`impl-exec-specific`)

Executes specific tasks by ID:

```bash
/impl-exec-specific foundation-and-core TASK-001 TASK-002
```

Use this mode when:
- Re-running a failed task
- Testing a specific implementation
- You know exactly which tasks to run

---

## Execution Workflow

### Phase 1: Read PROGRESS.json

1. Read `impl-plans/PROGRESS.json` (~2K tokens)
2. Do NOT read individual plan files yet

### Phase 2: Identify Executable Tasks from PROGRESS.json

From PROGRESS.json, find tasks where:
1. **Phase is READY** (not BLOCKED or COMPLETED)
2. **Task status = "Not Started"**
3. **All dependencies are "Completed"**

```python
executable_tasks = []
for plan_name, plan in progress["plans"].items():
    phase = progress["phases"][str(plan["phase"])]
    if phase["status"] != "READY":
        continue  # Skip blocked phases

    for task_id, task in plan["tasks"].items():
        if task["status"] != "Not Started":
            continue

        # Check dependencies
        all_deps_complete = True
        for dep in task["deps"]:
            if ":" in dep:  # Cross-plan dep: "plan-name:TASK-xxx"
                dep_plan, dep_task = dep.split(":")
                if progress["plans"][dep_plan]["tasks"][dep_task]["status"] != "Completed":
                    all_deps_complete = False
            else:  # Same-plan dep: "TASK-xxx"
                if plan["tasks"][dep]["status"] != "Completed":
                    all_deps_complete = False

        if all_deps_complete:
            executable_tasks.append((plan_name, task_id))
```

### Phase 3: Execute Tasks (Sequential - ONE at a time)

For each executable task:

1. **Read the specific plan file** (only now, not before)
   ```
   impl-plans/active/{plan_name}.md
   ```

2. **Extract task details** from the plan file:
   - Deliverables
   - Completion Criteria
   - Description

3. **Invoke ts-coding agent** (sequential, NOT background)

4. **Run check-and-test-after-modify**

5. **Run review cycle** (ts-review, up to 3 iterations)

6. **Update plan file** - Change task status to "Completed"

7. **Update PROGRESS.json** - Change task status to "Completed"

**CRITICAL**: Execute tasks ONE AT A TIME. Do NOT use `run_in_background: true`.

### Phase 4: Update PROGRESS.json

After each task completes, update `impl-plans/PROGRESS.json`:

```json
// Before:
"TASK-001": { "status": "Not Started", "parallelizable": true, "deps": [] }

// After:
"TASK-001": { "status": "Completed", "parallelizable": true, "deps": [] }
```

Also update `lastUpdated` timestamp.

### Phase 5: Report Results

Report:
- Tasks executed
- Review iterations per task
- Newly unblocked tasks
- Phase transitions if applicable

---

## Task Invocation Format

When invoking the `ts-coding` agent for a task:

```
Task tool parameters:
  subagent_type: ts-coding
  prompt: |
    Purpose: <task description from implementation plan>
    Reference Document: impl-plans/active/<plan-name>.md
    Implementation Target: <deliverables list>
    Completion Criteria:
      - <criterion 1 from task>
      - <criterion 2 from task>
      - <criterion N from task>
```

**NOTE**: Do NOT use `run_in_background: true`. Execute tasks sequentially.

### Extracting Task Information

Extract prompt content from the task structure in the implementation plan:

```markdown
### TASK-001: Core Interfaces

**Status**: Not Started
**Parallelizable**: Yes
**Deliverables**:        <- Use for Implementation Target
- `src/interfaces/filesystem.ts`
- `src/interfaces/process-manager.ts`

**Description**:         <- Use for Purpose
Define all core interfaces for abstracting external dependencies.

**Completion Criteria**: <- Use for Completion Criteria
- [ ] FileSystem interface defined
- [ ] ProcessManager interface defined
- [ ] Type checking passes
```

---

## Sequential Execution Pattern

**CRITICAL**: Execute tasks ONE AT A TIME to prevent LLM errors.

```
For each task in executable_tasks:
    1. Read specific plan file (if not already read)
    2. Invoke ts-coding (wait for completion)
    3. Invoke check-and-test (wait for completion)
    4. Invoke ts-review (wait for completion)
    5. Update plan file status
    6. Update PROGRESS.json status
    7. Move to next task
```

Do NOT spawn multiple background tasks. This causes LLM errors and context issues.

---

## Result Collection Pattern

After each task execution:

1. Wait for ts-coding to complete (no background)
2. Parse task result (success/failure)
3. For completed task:
   - Verify completion criteria are met
   - Record any issues or partial completion
4. Update PROGRESS.json immediately

---

## Dependency Detection

Parse dependencies from plan:
```markdown
**Parallelizable**: No (depends on TASK-001)
```
or
```markdown
**Parallelizable**: No (depends on TASK-001, TASK-002)
```

## Dependency Resolution

### Dependency Types

| Type | Example | Resolution |
|------|---------|------------|
| **Data dependency** | Types must exist before using them | Execute sequentially |
| **File dependency** | Interface before implementation | Execute sequentially |
| **None** | Independent modules | Can be in same batch |

### Dependency Graph Example

```
TASK-001 (Interfaces)     TASK-002 (Errors)     TASK-003 (Types)
    |                          |                     |
    +----------+---------------+                     |
               |                                     |
    TASK-004 (Mocks)                        TASK-007 (Repo Interfaces)
```

From this graph:
- TASK-001, TASK-002, TASK-003 can be executed (in sequence, one at a time)
- TASK-004 must wait for TASK-001
- TASK-007 must wait for TASK-003

---

## Progress Tracking Format

### Task Status Values

| Status | Meaning |
|--------|---------|
| `Not Started` | Task not yet begun |
| `In Progress` | Currently being implemented |
| `Completed` | All completion criteria met |
| `Blocked` | Waiting on dependencies |

### Module Status Table

```markdown
## Module Status

| Module | File Path | Status | Tests |
|--------|-----------|--------|-------|
| Core Interfaces | `src/interfaces/*.ts` | Completed | Pass |
| Error Types | `src/errors.ts` | In Progress | - |
| Mock Implementations | `src/test/mocks/*.ts` | Not Started | - |
```

### Progress Log Entry

```markdown
### Session: 2026-01-04 14:30
**Tasks Completed**: TASK-001, TASK-002
**Tasks Started**: TASK-004
**Blockers**: None
**Notes**:
- Defined FileSystem, ProcessManager, Clock interfaces
- Added Result type with ok/err helpers
- Discovered need for additional WatchOptions type
```

---

## Completion Verification

### Per-Task Completion

A task is complete when:
- [ ] All deliverable files exist
- [ ] All completion criteria checkboxes can be checked
- [ ] Type checking passes (`bun run typecheck`)
- [ ] Tests pass (if tests are part of criteria)

### Per-Plan Completion

A plan is complete when:
- [ ] All tasks have status "Completed"
- [ ] Overall completion criteria are met
- [ ] Final type check passes
- [ ] Final test run passes

### Plan Finalization

When a plan is complete:

1. Update status header to "Completed"
2. Add final progress log entry
3. Move file: `impl-plans/active/<plan>.md` -> `impl-plans/completed/<plan>.md`
4. Update `impl-plans/README.md`
5. Update `impl-plans/PROGRESS.json` (remove completed plan or mark as completed)

---

## Review Cycle

After task implementation and testing, each task goes through a code review cycle using the `ts-review` agent.

### Review Workflow

```
ts-coding agent (implementation)
    |
    v
check-and-test-after-modify agent (tests pass)
    |
    v
ts-review agent (iteration 1)
    |
    +-- APPROVED --> Task complete
    |
    +-- CHANGES_REQUESTED --> ts-coding (fixes) --> check-and-test --> ts-review (iteration 2)
                                                                            |
                                                                            +-- ... (up to 3 iterations)
```

### Maximum Iterations

The review cycle is limited to **3 iterations** per task to prevent infinite loops:

| Iteration | Review Scope | Outcome |
|-----------|--------------|---------|
| 1 | Full comprehensive review | APPROVED or CHANGES_REQUESTED |
| 2 | Focus on previous issues + new issues from fixes | APPROVED or CHANGES_REQUESTED |
| 3 | Critical issues only | APPROVED (with documented remaining issues) |

### Review Agent Invocation

```
Task tool parameters:
  subagent_type: ts-review
  prompt: |
    Design Reference: <path to design document>
    Implementation Plan: impl-plans/active/<plan-name>.md
    Task ID: TASK-XXX
    Implemented Files:
      - <file path 1>
      - <file path 2>
    Iteration: 1
```

### Re-Review After Fixes

```
Task tool parameters:
  subagent_type: ts-review
  prompt: |
    Design Reference: <path to design document>
    Implementation Plan: impl-plans/active/<plan-name>.md
    Task ID: TASK-XXX
    Implemented Files:
      - <file path 1>
      - <file path 2>
    Iteration: 2
    Previous Feedback:
      - C1: Missing readonly modifiers
      - S1: Duplicate validation logic
    Focus Areas: readonly modifiers, duplicate validation
```

### Handling Review Results

**If APPROVED**:
1. Mark task as Completed
2. Update completion criteria checkboxes
3. Add review approval to progress log
4. Update PROGRESS.json

**If CHANGES_REQUESTED**:
1. Check current iteration number
2. If iteration < 3:
   - Parse issue list from review
   - Invoke ts-coding with fix instructions
   - Run check-and-test
   - Invoke ts-review with iteration + 1
3. If iteration >= 3:
   - Mark task as Completed
   - Document remaining issues in progress log
   - Note: "Approved after max iterations with documented issues"

### Review Feedback to ts-coding

When re-invoking ts-coding to fix review issues:

```
Task tool parameters:
  subagent_type: ts-coding
  prompt: |
    Purpose: Fix code review issues for TASK-XXX
    Reference Document: impl-plans/active/<plan-name>.md
    Implementation Target: Fix the following review issues

    Issues to Fix:
    - C1 (Critical): src/foo.ts:25 - Missing required method X
      Suggested Fix: Add method X per design spec section Y
    - C2 (Critical): src/bar.ts:42 - Using `any` type
      Suggested Fix: Replace with `unknown` and add type guard
    - S1 (Improvement): src/foo.ts:30,45 - Duplicate validation logic
      Suggested Fix: Extract to shared validateX function

    Completion Criteria:
      - All critical issues (C1, C2) are resolved
      - Improvement suggestions addressed where reasonable
      - Type checking passes
      - Tests pass
```

### Progress Log with Review

```markdown
### Session: 2026-01-04 14:30
**Tasks Completed**: TASK-001
**Review Iterations**: 2
**Review Summary**:
- Iteration 1: 2 critical issues, 1 improvement suggestion
- Iteration 2: APPROVED (all issues resolved)
**Notes**:
- Fixed missing readonly modifiers
- Extracted duplicate validation to shared utility
```

---

## Error Handling

### Task Failure

If a ts-coding agent fails:

1. Record the failure in progress log
2. Keep task status as "In Progress" (not completed)
3. Document the error and recommended fix
4. Continue with other tasks if possible
5. Report failures to user for manual intervention

### Partial Completion

If only some tasks complete:

1. Update completed task statuses in PROGRESS.json
2. Update progress log with what completed
3. Document blockers for incomplete tasks
4. Report partial progress to user

---

## Quick Reference

| Action | Tool | Parameters |
|--------|------|------------|
| Read PROGRESS.json | Read | `impl-plans/PROGRESS.json` |
| Read specific plan | Read | `impl-plans/active/<plan>.md` |
| Execute task | Task | `subagent_type: ts-coding` |
| Collect results | (wait inline) | No background tasks |
| Update plan | Edit | Update status, checkboxes, log |
| Update PROGRESS.json | Edit | Update task status, timestamp |
| Move completed | Bash | `mv impl-plans/active/ impl-plans/completed/` |

---

## Common Response Formats

### Cross-Plan Success Response

```
## Cross-Plan Auto Execution Complete

### Mode
Cross-plan auto-select (using PROGRESS.json)

### Phase Status
| Phase | Status |
|-------|--------|
| 1 | COMPLETED |
| 2 | READY (current) |
| 3 | BLOCKED |
| 4 | BLOCKED |

### Tasks Executed

| Plan | Task | Review Iterations | Result |
|------|------|-------------------|--------|
| session-groups-types | TASK-001 | 1 (APPROVED) | Completed |
| command-queue-types | TASK-001 | 2 (APPROVED) | Completed |

### Execution Summary
- Tasks executed: 2
- Review cycles: 3 total iterations
- PROGRESS.json updated: Yes

### Newly Unblocked Tasks
- session-groups-types:TASK-007 (was waiting on TASK-001)
- session-groups-runner:TASK-003 (was waiting on TASK-001, TASK-002)

### Next Steps
Run `/impl-exec-auto` again to execute newly unblocked tasks.
```

### No Executable Tasks Response

```
## No Executable Tasks

### Analysis (from PROGRESS.json)
| Phase | Status | Executable Tasks |
|-------|--------|------------------|
| 1 | COMPLETED | - |
| 2 | READY | 0 (all have unmet deps) |
| 3 | BLOCKED | Waiting on Phase 2 |
| 4 | BLOCKED | Waiting on Phase 3 |

### Blocking Tasks
The following tasks are blocking progress:
- session-groups-types:TASK-001 (In Progress)
- command-queue-core:TASK-003 (waiting on TASK-002)

### Recommended Actions
1. Wait for in-progress tasks to complete
2. Use `/impl-exec-specific` to run specific tasks
```

### Plan Completed Response

```
## Implementation Plan Completed

### Plan
`impl-plans/completed/<plan-name>.md` (moved from active/)

### Final Verification
- Type checking: Pass
- Tests: Pass (X/X)

### Plan Finalization
- Status updated to: Completed
- Moved to: impl-plans/completed/
- README.md updated
- PROGRESS.json updated

### Next Steps
- Review completed implementation
- Consider integration testing
- Proceed to next implementation plan
```

### Partial Failure Response

```
### Failure Details

**TASK-XXX Failure**:
- Error: <error type>
- Details: <specific error message>
- Files affected: <file paths>

### Recommended Actions
1. Review failure details
2. Fix the issue
3. Re-run with: `/impl-exec-specific <plan-name> TASK-XXX`
```

---

## Important Guidelines

1. **Read PROGRESS.json first**: Always read PROGRESS.json before execution
2. **Read plans lazily**: Only read specific plan files when executing tasks
3. **Execute sequentially**: Run tasks ONE AT A TIME (no background)
4. **Update immediately**: Update both plan file AND PROGRESS.json after each task
5. **Fail gracefully**: Continue with other tasks if one fails
6. **Invoke check-and-test**: After ts-coding completes, invoke `check-and-test-after-modify`
7. **Run review cycle**: After tests pass, invoke `ts-review` for code review (max 3 iterations)
8. **Move completed plans**: Move to `impl-plans/completed/` when done

---

## IMPORTANT: Always Update PROGRESS.json

After ANY task status change:
1. Edit the task status in `impl-plans/PROGRESS.json`
2. Update the `lastUpdated` timestamp
3. Edit the task status in the plan file

This keeps PROGRESS.json in sync and enables fast cross-plan analysis.

---

## Integration with Other Skills

| Skill/Agent | Relationship |
|-------------|--------------|
| `impl-plan/SKILL.md` | Read plans created by this skill |
| `ts-coding-standards/` | ts-coding agent follows these |
| `design-doc/SKILL.md` | Original design reference |
| `ts-review` agent | Code review after implementation |
| `check-and-test-after-modify` agent | Test verification before review |
