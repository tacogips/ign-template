---
description: Fix merge conflicts in the current PR (user)
---

## Required Email Privacy Check

Follow the **Git Email Privacy Gate** in the repository-root `AGENTS.md` before
any commit, tag, or push in this workflow, including delegated operations and
release/tap checkouts. Recheck the final staged snapshot and commit message,
verify raw author/committer/tagger metadata, and scan every outgoing ref's history
before pushing. A private-address match or incomplete check blocks the Git
operation; automatic/non-blocking workflow steps do not waive this gate.

## Context

- Current branch: !`git branch --show-current`
- Default branch: !`git remote show origin | grep 'HEAD branch' | cut -d' ' -f5`
- Existing PR for current branch: !`gh pr view --json number,title,url,baseRefName,mergeable,mergeStateStatus 2>/dev/null || echo "No PR found"`

## Your Task

Fetch the current branch's pull request, check for merge conflicts, pull both the base branch and current branch to get the conflict state, and automatically resolve the conflicts by creating a commit.

**This command only works when a PR exists for the current branch and has merge conflicts.**

## Conflict Resolution Process

### Step 0: Check for uncommitted changes

Before proceeding with conflict resolution, verify there are no uncommitted changes:

```bash
git status --porcelain
```

If uncommitted changes exist:
- Display error message: "Uncommitted changes detected. Please commit or stash your changes before resolving conflicts."
- Exit without proceeding

### Step 1: Verify PR exists and has conflicts

**Using gh CLI:**
```bash
gh pr view --json number,title,url,baseRefName,headRefName,mergeable,mergeStateStatus
```

**Using GraphQL API (for more detailed conflict information):**
```bash
gh api graphql -f query='
query {
  repository(owner: "{owner}", name: "{repo}") {
    pullRequest(number: {pr_number}) {
      number
      title
      url
      baseRefName
      headRefName
      mergeable
      mergeStateStatus
      files(first: 100) {
        nodes {
          path
          additions
          deletions
          changeType
        }
      }
      commits(last: 1) {
        nodes {
          commit {
            oid
          }
        }
      }
    }
  }
}'
```

Parse the response to check:
- `mergeable` field: Should be `CONFLICTING` for conflicts to exist
- `mergeStateStatus` field: Provides additional context (BEHIND, BLOCKED, CLEAN, DIRTY, UNSTABLE)

**If no conflicts detected:**
- Report "No merge conflicts detected in PR #{number}"
- Exit successfully

**If conflicts detected:**
- Report "Merge conflicts detected in PR #{number}"
- Proceed to Step 2

### Step 2: Pull base branch and get conflict state

```bash
# Fetch latest from remote
git fetch origin

# Attempt to merge base branch to get conflict markers
git merge origin/{base_branch}
```

If merge fails with conflicts:
- List conflicting files using `git diff --name-only --diff-filter=U`
- Report the list of conflicting files

### Step 3: Analyze and resolve conflicts

For each conflicting file:

1. **Read the file with conflict markers** using Read tool
   - Identify conflict sections marked by:
     ```
     <<<<<<< HEAD
     ... (current branch changes)
     =======
     ... (base branch changes)
     >>>>>>> origin/{base_branch}
     ```

2. **Analyze both versions**:
   - Understand what changes were made in each branch
   - Determine the intent of both changes
   - Check if changes are complementary or contradictory

3. **Determine resolution strategy**:
   - **Both changes needed**: Merge both sets of changes logically
   - **Current branch correct**: Keep current branch version
   - **Base branch correct**: Keep base branch version
   - **New solution needed**: Create a combined solution that preserves both intents

4. **Apply fix using Edit tool**:
   - Remove conflict markers
   - Apply the resolved content
   - Ensure proper formatting and syntax

5. **Mark as resolved**:
   ```bash
   git add {resolved_file_path}
   ```

**Use TodoWrite to track conflict resolution progress:**
- One todo item per conflicting file
- Mark as in_progress when starting to resolve
- Mark as completed when file is resolved and added

### Step 4: Verify resolution

After resolving all conflicts:

```bash
# Check for any remaining conflict markers
git diff --check

# Verify compilation
go build ./...

# Check formatting
gofmt -l .

# Run tests
go test ./... -v
```

If verification fails:
- Identify the issue
- Re-analyze and fix the problematic resolution
- Re-run verification

### Step 5: Create conflict resolution commit

```bash
git commit -m "$(cat <<'EOF'
fix: resolve merge conflicts from {base_branch}

Resolved conflicts in the following files:
- {file1}: {brief description of resolution}
- {file2}: {brief description of resolution}

Resolution approach:
- {Describe the general approach taken to resolve conflicts}

Verification:
- Compilation: PASS
- Tests: PASS
- Format: PASS
EOF
)"
```

### Step 6: Push the resolution

**CRITICAL**: Only push if the user explicitly requests it.

```bash
git push origin {head_branch}
```

Display final summary:
```
## Conflict Resolution Summary

**PR**: #{number} - {title}
**Base Branch**: {base_branch}

### Resolved Files:
- {file_path}: {resolution_summary}

### Verification Results:
- Compilation: PASS/FAIL
- Tests: PASS/FAIL
- Format: PASS/FAIL

### Next Steps:
- Review the resolution
- Push to remote (if ready)
- Verify PR is now mergeable
```

## Important Notes

### Current Branch Only
- This command only works for PRs associated with the current branch
- It does NOT accept PR number arguments
- Execute in the repository directory with an active PR

### Uncommitted Changes Check
- The command checks for uncommitted changes first
- Any uncommitted changes will prevent the command from running
- This ensures a clean working directory for conflict resolution

### Conflict Resolution Strategies

**For code changes:**
- Understand the intent of both changes before resolving
- Prefer preserving functionality from both branches when possible
- If changes are incompatible, understand which is more recent or correct

**For import statements:**
- Combine all needed imports
- Remove duplicates
- Ensure proper ordering (standard library, third-party, local)

**For test files:**
- Preserve all test cases from both branches
- Ensure test data is consistent with resolved production code

**For configuration files (go.mod, go.sum):**
- Run `go mod tidy` after resolving to ensure consistency
- Keep the higher version when version conflicts occur

### Verification Requirements
- Always run `go build` after resolution
- Always run `gofmt` to check formatting
- Run `go test` to verify no regressions
- Check for remaining conflict markers using `git diff --check`

### Commit Policy
- **CRITICAL**: Only push if the user explicitly instructs to do so
- Default behavior: Create the resolution commit but do not push
- If user says "push": Then perform Step 6

### GitHub Integration
The command uses:
- `gh pr view` - Get PR information and conflict status
- `git merge` - Get conflict state locally
- `git diff` - Identify conflicting files
- `git add` and `git commit` - Stage and commit resolutions
