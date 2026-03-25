# Checklist Phase — Requirements Quality Checklists

## Purpose

Generate domain-specific checklists that validate the **quality of requirements**, not the behavior of the implementation. Think of checklists as "unit tests for requirements writing" — they verify that the spec is complete, clear, consistent, and testable before a single line of code is written.

## Critical Distinction: Requirements Quality vs. Implementation Testing

This is the most important concept in this phase. Every checklist item must test whether a **requirement is well-written**, not whether the **implementation works**.

### CORRECT — Testing Requirements Quality

These ask whether the spec adequately defines something:

- `Are visual hierarchy requirements defined for all card types?` [Completeness]
- `Is 'fast loading' quantified with specific timing thresholds?` [Clarity, Spec NFR-002]
- `Are hover state requirements consistent across all interactive elements?` [Consistency]
- `Do authentication requirements specify behavior for expired tokens?` [Scenario Coverage]
- `Is the maximum payload size defined for the upload endpoint?` [Non-Functional Requirements, Spec API-015]
- `Are error message requirements specified for all form validation states?` [Edge Case Coverage]
- `Can the 'responsive design' requirement be objectively measured against specific breakpoints?` [Acceptance Criteria Quality]

### WRONG — Testing Implementation (PROHIBITED)

These test whether something was built correctly. They belong in test suites, not requirements checklists:

- ~~`Verify landing page displays 3 episode cards`~~ -- this tests implementation behavior
- ~~`Test hover states work on desktop`~~ -- this tests implementation behavior
- ~~`Confirm logo click navigates home`~~ -- this tests implementation behavior
- ~~`Check that the API returns 200 for valid requests`~~ -- this tests implementation behavior
- ~~`Validate form shows error on empty submit`~~ -- this tests implementation behavior

### Prohibited Patterns

Never start a checklist item with these verbs followed by implementation behavior:

- "Verify [that something works/displays/returns]"
- "Test [that something functions/renders/responds]"
- "Confirm [that something happens/shows/navigates]"
- "Check [that something is built/deployed/running]"
- "Validate [that something passes/succeeds/completes]"

### Required Patterns

Checklist items should follow these structures:

- `Are [requirements for X] defined/specified/documented?`
- `Is [vague term] quantified with [specific measurable criteria]?`
- `Can [requirement] be objectively measured/verified/tested?`
- `Do [requirements] cover [edge case / failure mode / scenario]?`
- `Are [related requirements] consistent with each other?`
- `Does [requirement] specify [missing dimension — timing, size, format, etc.]?`

## Workflow

### Step 1 — Contextual Clarifying Questions

Before generating the checklist, ask **up to 3** clarifying questions to tailor the output. Focus on:

- **Scope**: Which domain should this checklist cover? (UX, security, API, accessibility, performance, data, etc.)
- **Risk appetite**: Are there high-risk areas that need deeper scrutiny?
- **Depth**: Should this be a broad survey or a deep dive into a specific area?
- **Audience**: Who will review this checklist? (product owner, architect, QA lead, etc.)

If the user has already specified the domain and context clearly, skip straight to generation. Do not ask unnecessary questions.

### Step 2 — Load Feature Context

Read the feature documents from `specs/<feature-name>/`:

- `spec.md` — primary source of requirements
- `plan.md` — architectural decisions and constraints
- `tasks.md` — implementation breakdown

Use these to understand the full scope of what needs to be checked. Every checklist item should trace back to something in these documents.

### Step 3 — Generate the Checklist

Write the checklist to: `specs/<feature-name>/checklists/<domain>.md`

Where `<domain>` is the checklist's focus area (e.g., `ux.md`, `security.md`, `api.md`, `accessibility.md`, `performance.md`, `data.md`).

**If the file already exists**, append new items starting from the next available CHK ID. Do not overwrite existing items. Scan for the highest existing CHK### and continue from there.

**If the file is new**, start numbering at CHK001.

#### File Format

```markdown
# <Domain> Requirements Quality Checklist — <feature-name>

> This checklist validates the quality of requirements, not implementation behavior.
> Each item asks whether the specification adequately defines, quantifies, or covers a concern.

## <Section Name>

- [ ] CHK001 Are [specific requirement aspect] defined for [scope]? [Quality Dimension, Spec <reference>]
- [ ] CHK002 Is [vague term from spec] quantified with [measurable criteria]? [Quality Dimension, Spec <reference>]
- [ ] CHK003 Do [requirements] specify behavior for [edge case]? [Quality Dimension, Spec <reference>]

## <Next Section Name>

- [ ] CHK004 ...
```

#### Quality Dimensions

Tag every item with at least one quality dimension:

| Dimension | What It Checks |
|-----------|---------------|
| Completeness | Are all necessary aspects of a requirement defined? |
| Clarity | Can the requirement be understood without ambiguity? |
| Consistency | Do related requirements agree with each other? |
| Acceptance Criteria Quality | Are acceptance criteria specific, measurable, and testable? |
| Scenario Coverage | Are all relevant user scenarios and workflows addressed? |
| Edge Case Coverage | Are boundary conditions, error states, and failure modes specified? |
| Non-Functional Requirements | Are performance, security, scalability, and reliability constraints quantified? |
| Dependencies & Assumptions | Are external dependencies and assumptions explicitly stated? |
| Ambiguities & Conflicts | Are terms precise and free from contradictions? |

### Step 4 — Apply Constraints

- **Soft cap: 40 items.** If the domain warrants more, you may go up to 50 but prefer merging related items rather than exceeding the cap.
- **Merge near-duplicates.** If two candidate items test essentially the same quality concern, combine them into one broader item.
- **Minimum 80% traceability.** At least 80% of items must include a reference to a specific spec section, requirement ID, or plan section (e.g., `Spec FR-003`, `Plan Section 4.2`, `Spec NFR-011`).
- **Section grouping.** Organize items into logical sections based on feature areas, not quality dimensions. For example, group by "Navigation", "Authentication", "Data Display" rather than by "Completeness", "Clarity", etc.

### Step 5 — Summary

After generating the checklist, provide a brief summary:

```
Generated <n> checklist items in <domain>.md
- Completeness: <n> items
- Clarity: <n> items
- Consistency: <n> items
- [other dimensions]: <n> items
- Traceability: <n>% of items reference specific spec sections
```

## Reminders

- You are testing the quality of the written requirements, not the quality of the software.
- If a requirement is vague, your checklist item should ask whether it has been made specific — not whether the implementation handles it correctly.
- Checklists should be useful to a product owner or architect reviewing the spec before development begins.
- When appending to an existing checklist, review existing items first to avoid adding duplicates.
