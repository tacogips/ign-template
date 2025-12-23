---
description: Fix merge conflicts in the current PR (user)
---

## Context

- Current branch: !`git branch --show-current`
- Default branch: !`git remote show origin | grep 'HEAD branch' | cut -d' ' -f5`
- Existing PR for current branch: !`gh pr view --json number,title,url,baseRefName,mergeable,mergeStateStatus 2>/dev/null || echo "No PR found"`

## Your task

Fetch the current branch's pull request, check for merge conflicts, pull both the base branch and current branch to get the conflict state, and automatically resolve the conflicts by creating a commit.

**This command only works when a PR exists for the current branch and has merge conflicts.**

## Conflict Resolution Process

### Step 0: Check for uncommitted changes

Before proceeding with conflict resolution, verify there are no uncommitted changes:

```bash
git status --porcelain
```

If uncommitted changes exist, display error and exit.

### Step 1: Verify PR exists and has conflicts

```bash
gh pr view --json number,title,url,baseRefName,headRefName,mergeable,mergeStateStatus
```

### Step 2: Pull base branch and get conflict state

```bash
git fetch origin
git merge origin/{base_branch}
```

### Step 3: Analyze and resolve conflicts

For each conflicting file:
1. Read the file with conflict markers
2. Analyze both versions
3. Determine resolution strategy
4. Apply fix using Edit tool
5. Mark as resolved with `git add`

### Step 4: Verify resolution

```bash
go build ./...
gofmt -l .
```

### Step 5: Create conflict resolution commit

### Step 6: Push the resolution

```bash
git push origin {head_branch}
```

## Important Notes

- Current Branch Only: This command only works for PRs associated with the current branch
- Uncommitted Changes Check: The command checks for uncommitted changes first
- Automated Resolution: The command attempts to automatically resolve conflicts
- Follow Go best practices and project guidelines for resolutions
