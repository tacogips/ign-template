---
description: Fix GitHub Actions errors from the current PR (user)
---

## Context

- Current branch: !`git branch --show-current`
- Default branch: !`git remote show origin | grep 'HEAD branch' | cut -d' ' -f5`
- Existing PR for current branch: !`gh pr view --json number,title,url 2>/dev/null || echo "No PR found"`

## Your task

Fetch the current branch's pull request, retrieve GitHub Actions check failures and error messages, analyze the errors, and fix them.

**This command only works when a PR exists for the current branch.**

## GitHub Actions Error Fix Process

### Step 1: Verify PR exists for current branch

```bash
gh pr view --json number,title,url,baseRefName,headRefName
```

### Step 2: Fetch GitHub Actions check status

```bash
gh pr checks
```

### Step 3: Fetch detailed error logs from failed checks

```bash
gh run view {run_id} --log-failed
```

### Step 4: Categorize and analyze errors

Group errors by type:
- Compilation Errors
- Test Failures
- Lint Errors
- Build Errors

### Step 5: Display error summary and plan fixes

Use TodoWrite to create fix tasks.

### Step 6: Fix errors systematically

For each error:
1. Read the relevant file
2. Analyze the error context
3. Apply the fix
4. Verify locally

### Step 7: Final verification

```bash
go build ./...
golangci-lint run ./...
gofmt -l .
go test ./... -v
```

### Step 8: Commit and push fixes (optional)

Only perform if user explicitly requests.

## Important Notes

- Current Branch Only: This command only works for PRs associated with the current branch
- Automated Fixing: The command attempts to automatically fix common issues
- Commit Policy: Only commit and push if user explicitly instructs
