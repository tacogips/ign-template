# Example: Source Access Scope

**Status**: Pending

**Created**: 2025-01-04

**Category**: Investigation Scope

## Question

Which external sources are approved for this investigation?

## Context

The investigation may involve browsing external sites, reading public documentation, or reviewing internal notes. The following factors need consideration:

- Reliability of sources
- Allowed authentication methods
- Whether browser automation is acceptable
- Whether screenshots or archived copies are required

## Options

| Option | Pros | Cons |
|--------|------|------|
| Public web only | Easy to verify, low coordination overhead | May miss important internal context |
| Public web + internal docs | Broader evidence base | Requires clearer access rules |
| Public web + browser automation | Reproducible flows and screenshots | Higher maintenance and review cost |

## Recommendation

Start with public web and explicitly list any internal sources before using them.

## Decision

(Awaiting user confirmation)

## Notes

- Add source attribution rules once scope is confirmed
- If browser automation is approved, record the target flows in `design-docs/specs/command.md`
