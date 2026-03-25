# Analyze Phase — Consistency Analysis

## Purpose

Perform a **read-only** consistency analysis across the spec, plan, and tasks for a feature. This phase identifies gaps, conflicts, ambiguities, and coverage issues before any implementation begins.

## Strict Constraints

- **NEVER modify any file.** This phase is strictly read-only.
- **NEVER apply remediations automatically.** You may suggest fixes but must wait for explicit user approval before any changes are made.

## Required Inputs

All files live under `specs/<feature-name>/`:

| File | Required | Description |
|------|----------|-------------|
| `spec.md` | Yes | Feature specification with requirements (FR-###, SC-###, NFR-###) |
| `plan.md` | Yes | Architecture and implementation plan |
| `tasks.md` | Yes | Task breakdown with phases, dependencies, and acceptance criteria |

Also load `specs/constitution.md` if it exists. The constitution defines project-wide MUST-level principles that override all feature specs.

If any required file is missing, stop and report which files are absent. Do not proceed with a partial analysis.

## Step 1 — Build Semantic Models

Parse the three documents and construct these internal models:

### Requirements Inventory

Extract every requirement identifier and its full text. Common patterns:

- `FR-###` — Functional requirements
- `SC-###` — Scenario or story-level requirements
- `NFR-###` — Non-functional requirements
- `UI-###`, `API-###`, `SEC-###` — Domain-specific identifiers

For each requirement, capture: ID, title/summary, acceptance criteria (if any), priority (if stated).

### User Story Inventory

Extract user stories (often in "As a ... I want ... so that ..." format). Map each story to the requirements it references or implies.

### Task Coverage Mapping

For every task in `tasks.md`, record:

- Task ID or number
- Which requirement(s) it addresses (explicit references or inferred from description)
- Phase and dependency information

### Constitution Rule Set

If `specs/constitution.md` exists, extract every MUST-level principle. These are non-negotiable constraints. Tag each with a short identifier for traceability.

## Step 2 — Run Detection Passes

Execute all six detection passes in order. Collect every finding with a severity level, location reference, and brief explanation.

### Pass A: Duplication Detection

Identify near-duplicate requirements — different IDs that describe the same capability or constraint. Look for:

- Identical or synonymous phrasing across different requirement IDs
- Requirements that would be satisfied by the same implementation
- Overlapping acceptance criteria

Flag pairs with a similarity note. Severity: HIGH if the duplicates could cause conflicting implementations, MEDIUM otherwise.

### Pass B: Ambiguity Detection

Scan for language that cannot be objectively verified:

- **Vague adjectives without metrics**: "fast", "responsive", "intuitive", "user-friendly", "simple", "secure", "scalable", "efficient", "modern", "clean"
- **Unresolved placeholders**: `TBD`, `TODO`, `[TBD]`, `<placeholder>`, `to be determined`
- **Unbounded quantifiers**: "various", "multiple", "many", "several", "etc.", "and so on"
- **Implicit assumptions**: "obviously", "of course", "naturally", "as expected"

Severity: HIGH if the ambiguity affects security, performance, or data integrity requirements. MEDIUM for UX or cosmetic requirements. LOW for purely stylistic wording issues.

### Pass C: Underspecification

Check for requirements that are structurally incomplete:

- Requirements missing a clear object (what is affected)
- Requirements missing a clear outcome (what should happen)
- Requirements with acceptance criteria that cannot be tested
- User stories with no corresponding acceptance criteria at all
- Error/failure scenarios not addressed for critical paths

Severity: HIGH for requirements on critical paths or involving data loss/security. MEDIUM otherwise.

### Pass D: Constitution Alignment

Compare every requirement and plan decision against the constitution rule set:

- Does any requirement contradict a MUST principle?
- Does the plan make architectural choices that violate constitution constraints?
- Are any constitution principles not reflected in either the spec or plan?

**Every constitution violation is CRITICAL severity.** No exceptions.

### Pass E: Coverage Gaps

Cross-reference the task coverage mapping against the requirements inventory:

- **Orphan requirements**: Requirements with zero tasks addressing them
- **Orphan tasks**: Tasks that do not trace back to any requirement
- **Partial coverage**: Requirements where tasks address some but not all acceptance criteria

Severity: CRITICAL for zero-coverage requirements on critical paths. HIGH for partial coverage. MEDIUM for orphan tasks (they may indicate scope creep or missing requirements).

### Pass F: Inconsistency

Detect semantic drift and contradictions across the three documents:

- **Terminology drift**: The same concept referred to by different names across documents (e.g., "user" vs "customer" vs "account holder")
- **Entity mismatches**: Entities mentioned in tasks that do not appear in the spec, or vice versa
- **Ordering contradictions**: Task dependencies that conflict with the plan's stated execution order
- **Numeric contradictions**: Different numbers for the same constraint (e.g., spec says "5 seconds" but plan says "3 seconds")
- **Scope drift**: Tasks that implement functionality beyond what the spec describes

Severity: HIGH for numeric contradictions and entity mismatches. MEDIUM for terminology drift. LOW for minor wording inconsistencies.

## Step 3 — Produce the Report

Generate a Markdown report with the following sections in order.

### Header

```markdown
# Consistency Analysis — <feature-name>
**Date:** <YYYY-MM-DD>
**Files analyzed:** spec.md, plan.md, tasks.md [, constitution.md]
```

### Findings Table

List findings sorted by severity (CRITICAL first), then by pass. Cap at **50 findings**. If more exist, note the overflow count and state that only the top 50 by severity are shown.

```markdown
## Findings

| # | Severity | Pass | Location | Finding | Suggested Remediation |
|---|----------|------|----------|---------|----------------------|
| 1 | CRITICAL | D | spec.md FR-012 | Contradicts constitution principle C-03 (must use encryption at rest) | Add encryption-at-rest requirement to FR-012 |
| 2 | HIGH | E | spec.md SC-007 | Zero tasks cover this scenario | Add implementation task for SC-007 in Phase 2 |
| ... | | | | | |
```

### Coverage Summary

```markdown
## Coverage Summary

| Metric | Count |
|--------|-------|
| Total requirements | <n> |
| Fully covered by tasks | <n> |
| Partially covered | <n> |
| Not covered | <n> |
| Coverage % | <n>% |
```

### Constitution Alignment

If a constitution was loaded, include a dedicated section:

```markdown
## Constitution Alignment

| Principle | Status | Notes |
|-----------|--------|-------|
| C-01: ... | PASS / FAIL | ... |
| C-02: ... | PASS / FAIL | ... |
```

### Unmapped Tasks

List any tasks that do not trace to a requirement:

```markdown
## Unmapped Tasks

| Task | Phase | Possible Requirement |
|------|-------|---------------------|
| Task 14: Set up CI pipeline | Phase 3 | (infrastructure — no spec requirement) |
```

### Metrics Summary

```markdown
## Metrics

- **Total requirements:** <n>
- **Total tasks:** <n>
- **Coverage:** <n>%
- **Ambiguity count:** <n>
- **Critical issues:** <n>
```

### Next Actions

Provide a prioritized list of recommended next steps, grouped by severity. Always phrase as suggestions, never as commands. Example:

```markdown
## Recommended Next Actions

### Critical (address before implementation)
1. Resolve constitution conflict in FR-012 (Finding #1)
2. Add tasks for uncovered requirement SC-007 (Finding #2)

### High
3. Clarify performance metric in NFR-003 — replace "fast" with a measurable threshold (Finding #5)

### Medium / Low
4. Standardize terminology: choose either "user" or "customer" and apply consistently (Finding #12)
```

## Reminders

- You are an analyst in this phase. Observe and report. Do not fix.
- If the user asks you to fix an issue, switch to the appropriate phase (spec, plan, tasks) to make changes. Do not make changes within the analyze phase.
- If the documents are too large to hold in context simultaneously, process them in stages but still run all six passes.
