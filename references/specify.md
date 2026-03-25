# Specify Phase: Creating a Feature Specification

This reference defines the complete workflow for transforming a natural language feature description into a structured, validated specification document.

---

## Overview

The specify phase takes a user's feature idea and produces:
- A git feature branch
- A structured spec at `specs/<feature-name>/spec.md`
- A quality validation checklist at `specs/<feature-name>/checklists/requirements.md`
- A validated, ready-to-clarify (or ready-to-implement) specification

The spec captures WHAT the system should do and WHY, never HOW. It is written for business stakeholders, not engineers.

---

## Step-by-Step Workflow

### Step 1: Generate a Branch Name

Derive a concise 2-4 word short name from the user's description using action-noun format.

**Good examples:** `user-auth`, `analytics-dashboard`, `fix-payment-timeout`, `export-csv-reports`, `onboard-flow`

**Bad examples:** `the-new-feature`, `update-stuff`, `v2`, `backend-refactor-of-the-auth-module`

Rules:
- Lowercase, hyphen-separated
- Action-noun pattern preferred (verb-object or adjective-noun)
- 2-4 words maximum
- Descriptive enough to understand at a glance

### Step 2: Determine the Next Sequential Number

Check existing branches and spec directories to find the next available number:

```bash
git branch -a
ls specs/ 2>/dev/null
```

Scan for any pattern matching `NNN-*` (e.g., `001-user-auth`, `002-dashboard`). The next number is the highest found + 1, zero-padded to 3 digits. If none exist, start at `001`.

### Step 3: Create the Feature Branch

```bash
git checkout -b <NNN-feature-name>
```

Example: `git checkout -b 003-export-csv-reports`

### Step 4: Create the Spec Directory

```bash
mkdir -p specs/<feature-name>/checklists
```

Use the feature name without the numeric prefix for the directory name. Example: `specs/export-csv-reports/`

### Step 5: Load the Spec Template

Read `templates/spec-template.md` from the project root to understand the required sections and formatting. If no template exists, use the canonical section structure defined in Step 7 below.

### Step 6: Parse the Feature Description

Extract from the user's natural language description:

| Element | What to look for |
|---|---|
| **Actors** | Who uses this? (end users, admins, systems, third parties) |
| **Actions** | What do they do? (verbs: create, view, export, approve) |
| **Data** | What entities/information are involved? |
| **Constraints** | Limits, rules, regulations, performance expectations |
| **Goals** | Why does this feature exist? What problem does it solve? |
| **Triggers** | What initiates the workflow? |
| **Outcomes** | What is the end state after the feature is used? |

### Step 7: Fill in the Spec Sections

Write the spec to `specs/<feature-name>/spec.md` with these sections:

#### Header

```markdown
# Feature: <Descriptive Feature Title>
**Branch:** <NNN-feature-name>
**Created:** <YYYY-MM-DD>
**Status:** Draft
```

#### Overview

2-3 sentences describing the feature, the problem it solves, and who it serves. Pure business language.

#### User Scenarios

Prioritize scenarios as P1 (must-have), P2 (important), P3 (nice-to-have).

Each scenario uses Given/When/Then acceptance format:

```markdown
### US-001: <Scenario Title> [P1]
**Actor:** <who>
**Given** <precondition>
**When** <action>
**Then** <expected outcome>

**Acceptance Criteria:**
- AC-001.1: <specific testable criterion>
- AC-001.2: <specific testable criterion>
```

Aim for 3-7 scenarios. Cover the happy path first, then key alternate and error paths.

#### Functional Requirements

Use `FR-###` format. Each requirement must be independently testable.

```markdown
- **FR-001:** The system shall allow users to <do something specific>.
- **FR-002:** When <condition>, the system shall <behavior>.
```

Rules for good functional requirements:
- Start with "The system shall..." or "When X, the system shall..."
- One behavior per requirement
- No implementation details (no "using Redis", "via REST API", "in the database")
- Testable: someone could write a pass/fail test for it
- Unambiguous: only one reasonable interpretation

#### Success Criteria

Use `SC-###` format. Every criterion must be measurable and technology-agnostic.

```markdown
- **SC-001:** Users can complete <task> in under <N> minutes.
- **SC-002:** <Metric> improves by at least <X>% compared to <baseline>.
```

**Good success criteria:**
- "Users can complete checkout in under 3 minutes"
- "95% of search queries return relevant results on the first page"
- "New users can complete onboarding without contacting support"

**Bad success criteria (never write these):**
- "API response time under 200ms" (implementation detail)
- "Database queries execute in under 50ms" (technology-specific)
- "React components render in under 16ms" (framework-specific)

#### Key Entities

List the core data objects/concepts with brief descriptions and key attributes:

```markdown
| Entity | Description | Key Attributes |
|---|---|---|
| Report | A generated data export | title, date range, format, status |
| Schedule | A recurring report configuration | frequency, recipients, filters |
```

#### Assumptions

List assumptions made during spec creation. These are things believed to be true but not explicitly stated by the user:

```markdown
- A-001: Users are already authenticated before accessing this feature.
- A-002: The system has access to the data source via existing integrations.
```

#### Open Questions

If any `[NEEDS CLARIFICATION]` markers exist, list them here with context.

### Step 8: Apply NEEDS CLARIFICATION Markers

For unclear aspects, follow this decision framework:

**Make an informed guess and move on (no marker needed) when:**
- There is a reasonable industry-standard default
- The choice does not significantly change feature scope
- The decision is easily reversible later

**Use `[NEEDS CLARIFICATION]` only when:**
- The decision significantly impacts scope (e.g., "should this support bulk operations or single-item only?")
- Multiple reasonable interpretations exist with meaningfully different outcomes
- No reasonable default exists
- Security or compliance implications are unclear

**Maximum 3 markers per spec.** If you find more than 3 ambiguities, resolve the least impactful ones with reasonable defaults and note them in Assumptions.

**Priority for what gets a marker:** Scope > Security > UX > Technical

### Step 9: Reasonable Defaults

Apply these defaults without asking the user. Note them in the Assumptions section.

| Area | Default |
|---|---|
| Data retention | Industry standard for the domain (e.g., 7 years financial, 90 days logs) |
| Performance | Standard web/mobile expectations (pages load in <3s, actions acknowledge in <1s) |
| Error handling | User-friendly messages, no technical details exposed, graceful degradation |
| Authentication | Standard session-based or OAuth2 depending on context |
| Authorization | Role-based access control with least-privilege principle |
| Integration patterns | REST/GraphQL for web, webhooks for events, standard file formats for import/export |
| Pagination | Default page sizes (20-50 items), with user-adjustable options |
| Sorting/Filtering | Sensible defaults (newest first, most relevant first) with user override |
| Notifications | Opt-in for non-critical, mandatory for security/compliance events |
| Accessibility | WCAG 2.1 AA compliance |
| Localization | Single language (English) unless the feature description implies otherwise |

### Step 10: Write the Quality Validation Checklist

Create `specs/<feature-name>/checklists/requirements.md`:

```markdown
# Requirements Quality Checklist
**Spec:** <feature-name>
**Date:** <YYYY-MM-DD>

## Validation Criteria

| # | Check | Pass? | Notes |
|---|---|---|---|
| 1 | No implementation details in spec (no tech stack, frameworks, libraries) | | |
| 2 | All functional requirements are independently testable | | |
| 3 | All success criteria are measurable and technology-agnostic | | |
| 4 | All user scenarios have complete Given/When/Then acceptance criteria | | |
| 5 | Edge cases and error paths are identified | | |
| 6 | Feature scope is clearly bounded (what is NOT included is stated or obvious) | | |
| 7 | All actors are identified and their permissions/roles are clear | | |
| 8 | Key entities and their relationships are defined | | |
| 9 | No more than 3 NEEDS CLARIFICATION markers remain | | |
| 10 | Assumptions are documented and reasonable | | |
```

### Step 11: Validate the Spec Against the Checklist

Run through each checklist item against the spec. For each failing check:

1. Identify the specific issue
2. Fix it in the spec
3. Re-validate

**Maximum 3 validation iterations.** If issues persist after 3 rounds, note remaining concerns in the checklist Notes column and proceed.

Common fixes during validation:
- Replace "the system will use X technology" with "the system shall provide Y capability"
- Replace vague requirements ("fast", "user-friendly") with measurable criteria
- Add missing error/edge case scenarios
- Split compound requirements into individual testable items

### Step 12: Present NEEDS CLARIFICATION Items (if any)

If markers remain after validation, present each to the user with an option table:

```markdown
### Clarification Needed: <Topic>

**Context:** <Why this matters and what it affects>

| Option | Description | Impact |
|---|---|---|
| A | <option> | <what changes in the spec> |
| B | <option> | <what changes in the spec> |
| C | <option> | <what changes in the spec> |

**Recommended:** Option <X> because <reasoning>.
```

The user can choose an option or provide their own answer. Integrate their response immediately into the spec.

### Step 13: Report Completion

Provide a summary:

```
Specification complete.

  Branch:    <NNN-feature-name>
  Spec:      specs/<feature-name>/spec.md
  Checklist: specs/<feature-name>/checklists/requirements.md
  Status:    <Draft | Ready for Clarification | Ready for Planning>

  Scenarios:    <N> (P1: <n>, P2: <n>, P3: <n>)
  Requirements: <N> functional requirements
  Clarifications needed: <N>

Next steps:
  - /spec-kit clarify   Resolve remaining ambiguities
  - /spec-kit plan      Decompose into implementation tasks
```

### Step 14: Update Agent Instruction Files (First Specify Only)

If this is the **first feature** being specified in the project (i.e., the `specs/` directory was just created, or no `<!-- spec-kit:sdd-context -->` marker exists in `CLAUDE.md`), read `references/agent-context.md` and create/update all four agent instruction files:

- `CLAUDE.md` (project root)
- `.github/copilot-instructions.md`
- `GEMINI.md` (project root)
- `AGENTS.md` (project root)

This ensures that any AI coding agent working in the project — whether or not it has the spec-kit skill loaded — understands the SDD framework and knows to look at the `specs/` directory.

On subsequent specify runs (when the marker already exists), skip this step.

---

## Principles

1. **WHAT and WHY, never HOW.** The spec describes desired behavior and outcomes. It never prescribes technology, architecture, or implementation approach.

2. **Business language.** Written so a product manager, designer, or business stakeholder can read and validate it without engineering knowledge.

3. **Testable and measurable.** Every requirement can be verified with a pass/fail test. Every success criterion has a measurable threshold.

4. **Bounded scope.** The spec makes clear what is included and, where helpful, what is explicitly excluded.

5. **Informed defaults over questions.** Prefer making a reasonable assumption (documented in Assumptions) over blocking on a clarification question. Reserve questions for decisions that materially change scope or risk.

6. **Progressive refinement.** The spec does not need to be perfect on the first pass. The clarify phase exists to resolve remaining ambiguity. Get to "good enough to review" quickly.
