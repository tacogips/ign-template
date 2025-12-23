---
description: Review the current directory's PR and fix identified issues (user)
argument-hint: [instruction]
---

## Context

- Current branch: !`git branch --show-current`
- Default branch: !`git remote show origin | grep 'HEAD branch' | cut -d' ' -f5`
- Existing PR for current branch: !`gh pr view --json number,title,isDraft,url 2>/dev/null || echo "No PR found"`

## Arguments

This command accepts optional instruction arguments that customize the review scope:

**Format**: `/review-current-pr-and-fix [instruction]`

**Examples**:
- `/review-current-pr-and-fix` - Review all changes in the PR (default behavior)
- `/review-current-pr-and-fix Review only files in pkg/document/` - Review only files in pkg/document/
- `/review-current-pr-and-fix Review only test files` - Review only test files

**Important**: Instructions apply to review phase only. Files excluded from review will not have issues identified.

## Your Task

Review the pull request for the current directory's branch, identify all review targets (diff sections and review comments), delegate each target to the review-single-target agent for analysis, then fix all identified issues in a separate review branch.

**This command only works when a PR exists for the current branch.**

Use the `review-current-pr-and-fix` agent to handle the complete workflow.

## Workflow Summary

1. Check current branch status
2. Verify PR exists
3. Collect review targets from PR diff
4. Review each target (single-file and cross-file)
5. Create review branch
6. Delegate fixes by package
7. Commit and push
8. Create PR from review branch

See `.claude/agents/review-current-pr-and-fix.md` for complete workflow details.
