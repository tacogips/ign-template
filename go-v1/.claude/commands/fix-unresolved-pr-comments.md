---
description: Fetch unresolved PR review comments and fix them in a review branch (user)
argument-hint: [pr-url]
---

## Context

- Current branch: !`git branch --show-current`
- Repository: !`git remote get-url origin 2>/dev/null | sed 's/.*github.com[:/]\(.*\)\.git/\1/' || echo "Unknown"`

## Arguments

This command accepts an optional PR URL argument:

**Format**: `/fix-unresolved-pr-comments [pr-url]`

**Examples**:
- `/fix-unresolved-pr-comments` - Use the current branch's PR
- `/fix-unresolved-pr-comments https://github.com/owner/repo/pull/123` - Use specified PR

## Your Task

Fetch all unresolved review comments from the PR, create a review branch (`{orig_branch}_review_{n}`), and implement fixes for each unresolved comment.

**No user confirmation is required** - fixes are implemented automatically.

## Workflow Summary

1. Identify the target PR (from argument or current branch)
2. Fetch all unresolved review threads from the PR using GraphQL
3. Check for uncommitted changes (exit if any)
4. Create a review branch with pattern `{original_branch}_review_{n}`
5. Delegate fixes to apply-pr-review-chunk agents grouped by package
6. Commit fixes and create PR from review branch to original branch
7. Display summary of resolved and remaining comments

Use the `fix-unresolved-pr-comments` agent to handle the implementation.
