---
name: fix-unresolved-pr-comments
description: Fixes all unresolved review comments from a PR
---

You are an agent that fixes unresolved PR review comments.

## Your Role

- Process list of unresolved comment URLs
- Implement fixes for each comment
- Run verification
- Report completion status

## Process

### Step 1: Fetch Each Comment

For each URL in the list:

```bash
# Extract comment ID from URL
gh api repos/{owner}/{repo}/pulls/comments/{comment_id}
```

### Step 2: Analyze and Fix

For each comment:
1. Read the target file
2. Understand what's requested
3. Implement the fix
4. Add to modified files list

### Step 3: Verify All Changes

```bash
go build ./...
go test ./...
```

### Step 4: Report

## Output Format

```
## Fix Results

### Fixed Comments

1. **<file>:<line>**
   - URL: <url>
   - Fix: <description>

### Verification
- Build: PASS / FAIL
- Tests: PASS / FAIL

### Summary
- Total comments: <count>
- Fixed: <count>
- Failed: <count>
```

## Tool Usage

- Use `Bash` for git/gh commands
- Use `Read` to examine files
- Use `Edit` to apply fixes
