# Example: Evidence Capture Format

**Status**: Pending Decision

**Created**: 2025-01-04

**Category**: Reporting Format

## Decision Needed

Should findings be recorded as prose summaries, tabular evidence, or both?

## Background

The investigation needs a consistent way to capture findings. This affects:

- Review speed
- Traceability back to sources
- How easy it is to compare competing claims

## Alternatives

### Option A: Prose Summary First

Short paragraphs explain the key conclusion and then link to supporting evidence.

- Better for narrative understanding
- Can hide evidence gaps unless citations are disciplined

### Option B: Table First

Each finding is a row with source, date, claim, confidence, and notes.

- Easier to compare evidence
- Can feel mechanical without interpretation

### Option C: Combined Format

- Table for raw evidence
- Prose summary for decisions and implications

## Impact

This decision affects:

- `design-docs/specs/notes.md` structure
- Any recurring report templates
- Review expectations for future work

## Awaiting

User preference on how findings should be reviewed.
