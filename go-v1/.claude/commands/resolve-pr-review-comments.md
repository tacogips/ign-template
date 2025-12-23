---
description: Verify and resolve PR review comments that have been addressed and merged (user)
argument-hint: [pr-url]
---

## Context

- Current branch: !`git branch --show-current`
- Repository: !`git remote get-url origin 2>/dev/null | sed 's/.*github.com[:/]\(.*\)\.git/\1/' || echo "Unknown"`

## Arguments

This command accepts an optional PR URL argument:

**Format**: `/resolve-pr-review-comments [pr-url]`

**Examples**:
- `/resolve-pr-review-comments` - Use the current branch's PR
- `/resolve-pr-review-comments https://github.com/owner/repo/pull/123` - Use specified PR

## Your Task

Verify which PR review comments have been addressed by commits and automatically resolve those comments on GitHub. This command compares the current source code with the source at the time of review to determine if issues have been fixed.

**No user confirmation is required** - resolved comments are automatically updated.

Use the `verify-pr-comment-resolution` agent to handle the verification and resolution.

## Workflow Summary

1. Identify the target PR (from argument or current branch)
2. Fetch all unresolved review comments from the PR
3. For each comment, compare the source at review time vs. current source
4. Determine if the issue has been fixed by analyzing code changes
5. Automatically resolve verified comments on GitHub
6. Display summary of resolved and remaining comments
