# Spec-Kit: Spec-Driven Development for AI Coding Assistants

A comprehensive skill that implements **Spec-Driven Development (SDD)** — a methodology where specifications are the primary development artifact and code is treated as a generated output. Inspired by [GitHub's spec-kit](https://github.com/github/spec-kit) project, this skill adapts the full SDD pipeline into a self-contained skill for Claude Code.

Instead of jumping straight to code, SDD guides you through a structured pipeline: define project principles, write a feature specification, plan the technical approach, break it into tasks, and then implement — with consistency checks at every stage.

## Table of Contents

- [Why Spec-Driven Development?](#why-spec-driven-development)
- [Quick Start](#quick-start)
- [The Pipeline](#the-pipeline)
  - [1. Constitution](#1-constitution)
  - [2. Specify](#2-specify)
  - [3. Clarify](#3-clarify)
  - [4. Plan](#4-plan)
  - [5. Tasks](#5-tasks)
  - [6. Analyze](#6-analyze)
  - [7. Checklist](#7-checklist)
  - [8. Implement](#8-implement)
- [Directory Structure](#directory-structure)
- [Artifact Flow](#artifact-flow)
- [Templates](#templates)
- [Example Walkthrough](#example-walkthrough)
- [When to Use Each Command](#when-to-use-each-command)
- [Key Concepts](#key-concepts)
- [Multi-Agent Support](#multi-agent-support)
- [Skill Architecture](#skill-architecture)

## Why Spec-Driven Development?

Traditional development often starts with code and retrofits documentation. SDD inverts this:

1. **Specifications are the lingua franca** — the spec is the primary artifact. Code is its expression in a particular language.
2. **Intent before implementation** — describe WHAT and WHY in natural language, defer HOW to the planning phase.
3. **Continuous refinement** — AI analyzes specs for ambiguity, contradictions, and gaps throughout the process.
4. **Incremental delivery** — every user story is independently testable and deployable.

The result: fewer rewrites, clearer requirements, and code that actually matches what was asked for.

## Quick Start

### Starting a brand new feature

```
You: I want to build a URL shortener service with analytics tracking

Claude: [reads references/specify.md, creates branch, writes spec.md with user stories,
         functional requirements, success criteria, and assumptions]
```

### If you want project-wide principles first

```
You: Let's set up a constitution for this project — we want library-first architecture,
     test-driven development, and no unnecessary abstractions

Claude: [reads references/constitution.md, creates specs/constitution.md with versioned
         principles that govern all future work]
```

### Picking up mid-stream

If you already have a spec and want to move to planning:

```
You: Create a plan for the url-shortener feature. I'm building with Python 3.12,
     FastAPI, PostgreSQL, and pytest

Claude: [reads references/plan.md, generates plan.md, research.md, data-model.md,
         contracts/, and quickstart.md]
```

## The Pipeline

### 1. Constitution

**Reference**: `references/constitution.md`
**Output**: `specs/constitution.md`

Establishes non-negotiable project principles that govern all subsequent work. Think of it as your project's architectural DNA. Examples: "library-first architecture", "test-driven development is mandatory", "no unnecessary abstractions".

The constitution is **optional** but powerful — once created, every spec, plan, and task is validated against it. Constitution violations are always flagged as CRITICAL severity.

Uses semantic versioning: MAJOR for principle removals/redefinitions, MINOR for new principles, PATCH for clarifications.

### 2. Specify

**Reference**: `references/specify.md`
**Inputs**: Natural language feature description
**Outputs**: `specs/<feature-name>/spec.md`, `specs/<feature-name>/checklists/requirements.md`

Transforms a natural language feature description into a structured specification. This is the entry point for new features.

What happens:
- Creates a numbered feature branch (e.g., `001-url-shortener`)
- Generates prioritized user stories (P1/P2/P3) with Given/When/Then acceptance scenarios
- Defines functional requirements (FR-###) that are testable and unambiguous
- Sets measurable, technology-agnostic success criteria (SC-###)
- Identifies key entities and documents assumptions
- Creates a quality validation checklist and self-validates (up to 3 iterations)
- Limits `[NEEDS CLARIFICATION]` markers to 3 maximum, preferring informed guesses

Key principle: **Specs describe WHAT and WHY, never HOW**. No tech stack, no implementation details. Written for business stakeholders.

### 3. Clarify

**Reference**: `references/clarify.md`
**Inputs**: Existing `spec.md`
**Outputs**: Updated `spec.md` with clarifications integrated

An interactive Q&A session (max 5 questions) to reduce ambiguity in the spec before planning. Scans across 10 taxonomy categories:

| Category | What it checks |
|----------|---------------|
| Functional Scope | Core goals, out-of-scope declarations, user roles |
| Domain & Data Model | Entities, relationships, state transitions, scale |
| Interaction & UX | Critical journeys, error/empty/loading states |
| Non-Functional Quality | Performance, scalability, reliability, security |
| Integration & Dependencies | External services, failure modes, data formats |
| Edge Cases | Negative scenarios, rate limiting, conflicts |
| Constraints & Tradeoffs | Technical constraints, rejected alternatives |
| Terminology | Canonical glossary terms, avoided synonyms |
| Completion Signals | Acceptance criteria testability |
| Misc / Placeholders | TODO markers, vague adjectives lacking quantification |

Questions are presented one at a time with a recommended answer. Answers are immediately integrated into the relevant spec sections and saved.

### 4. Plan

**Reference**: `references/plan.md`
**Inputs**: `spec.md`, `constitution.md` (if exists), user's tech stack choices
**Outputs**: `plan.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md`

This is where the tech stack enters the picture. The user provides their technology choices and the plan phase generates:

| Artifact | Purpose |
|----------|---------|
| `plan.md` | Technical context, constitution check, project structure, complexity tracking |
| `research.md` | Resolved NEEDS CLARIFICATION items with Decision/Rationale/Alternatives |
| `data-model.md` | Entity definitions, fields, relationships, validation rules |
| `contracts/` | Interface contracts (API specs, CLI schemas, etc.) |
| `quickstart.md` | Integration and test scenarios |

Includes a **Constitution Check gate** — the plan must comply with project principles before research begins, and is re-checked after design is complete.

### 5. Tasks

**Reference**: `references/tasks.md`
**Inputs**: `plan.md` (required), `spec.md` (required), optional design artifacts
**Outputs**: `tasks.md`

Generates an actionable, dependency-ordered task list organized by user story. Every task follows a strict format:

```
- [ ] T001 [P] [US1] Create User model in src/models/user.py
```

| Component | Meaning |
|-----------|---------|
| `- [ ]` | Markdown checkbox (required) |
| `T001` | Sequential task ID (required) |
| `[P]` | Parallelizable — different files, no dependencies (optional) |
| `[US1]` | User story label — required in story phases, omitted in setup/polish |
| Description | Clear action with exact file path (required) |

Phase structure:
1. **Setup** — project initialization
2. **Foundational** — blocking prerequisites (MUST complete before any user story)
3. **User Story 1 (P1)** — MVP, independently testable
4. **User Story 2 (P2)** — independently testable
5. **...more stories by priority...**
6. **Polish** — cross-cutting concerns

Tests are **optional** — only generated if explicitly requested.

### 6. Analyze

**Reference**: `references/analyze.md`
**Inputs**: `spec.md`, `plan.md`, `tasks.md`
**Outputs**: Markdown analysis report (to conversation, not files)

A **read-only** consistency and quality analysis across all three core artifacts. Runs six detection passes:

| Pass | What it finds |
|------|--------------|
| Duplication | Near-duplicate requirements |
| Ambiguity | Vague adjectives, unresolved placeholders |
| Underspecification | Missing objects/outcomes, uncovered acceptance criteria |
| Constitution Alignment | Conflicts with MUST principles (always CRITICAL) |
| Coverage Gaps | Requirements with zero tasks, orphan tasks |
| Inconsistency | Terminology drift, missing entities, ordering contradictions |

Outputs: findings table (max 50), coverage summary, metrics (coverage %, ambiguity count, critical issues), and recommended next actions. Never modifies files — only offers remediation suggestions.

### 7. Checklist

**Reference**: `references/checklist.md`
**Inputs**: `spec.md`, optionally `plan.md` and `tasks.md`
**Outputs**: `specs/<feature-name>/checklists/<domain>.md`

Generates domain-specific quality checklists that function as **"unit tests for requirements writing"**. They validate whether requirements are complete, clear, consistent, and measurable — NOT whether implementation works.

**Correct** (testing requirements quality):
- "Are visual hierarchy requirements defined for all card types?" [Completeness]
- "Is 'fast loading' quantified with specific timing thresholds?" [Clarity]

**Wrong** (testing implementation — prohibited):
- "Verify landing page displays 3 cards"
- "Test hover states work on desktop"

Available any time after a spec exists. Multiple domain-specific checklists can coexist (e.g., `ux.md`, `security.md`, `api.md`, `performance.md`).

### 8. Implement

**Reference**: `references/implement.md`
**Inputs**: `tasks.md`, `plan.md`, optional design artifacts
**Outputs**: Implemented code, updated `tasks.md` with completed items marked `[X]`

Executes all tasks from tasks.md phase by phase:

1. **Checklist gate** — if checklists exist, verifies they're complete before proceeding
2. **Project setup** — creates/verifies .gitignore and other ignore files for the detected tech stack
3. **Phase-by-phase execution** — respects dependencies, runs parallel `[P]` tasks together
4. **Progress tracking** — reports after each task, halts on sequential failures
5. **Completion validation** — verifies features match spec, tests pass

Marks each completed task as `[X]` in tasks.md for tracking.

## Directory Structure

When this skill is used in a project, it creates and maintains:

```
<project-root>/
  specs/
    constitution.md                  ← Project principles (optional, shared across features)
    001-url-shortener/               ← Feature directory (named after branch)
      spec.md                        ← Feature specification (from /specify)
      plan.md                        ← Implementation plan (from /plan)
      research.md                    ← Tech research findings (from /plan)
      data-model.md                  ← Entity definitions (from /plan)
      contracts/                     ← Interface contracts (from /plan)
        api-v1.md
      quickstart.md                  ← Integration scenarios (from /plan)
      tasks.md                       ← Task breakdown (from /tasks)
      checklists/                    ← Quality checklists
        requirements.md              ← Auto-generated during /specify
        ux.md                        ← Domain-specific (from /checklist)
        security.md                  ← Domain-specific (from /checklist)
```

Feature directories use numbered prefixes matching the git branch (e.g., `001-url-shortener`). The numbering is auto-detected from existing branches and `specs/` directories.

## Artifact Flow

```
                    ┌──────────────┐
                    │ constitution │  (optional, project-wide)
                    └──────┬───────┘
                           │ principles govern all ↓
                    ┌──────┴───────┐
  user description ─┤   specify    ├─→ spec.md + requirements checklist
                    └──────┬───────┘
                           │
                    ┌──────┴───────┐
                    │   clarify    │  (optional, interactive Q&A)
                    └──────┬───────┘
                           │
  tech stack choices ──┐   │
                    ┌──┴───┴───────┐
                    │     plan     ├─→ plan.md, research.md, data-model.md,
                    └──────┬───────┘   contracts/, quickstart.md
                           │
                    ┌──────┴───────┐
                    │    tasks     ├─→ tasks.md
                    └──────┬───────┘
                           │
                    ┌──────┴───────┐
                    │   analyze    │  (optional, read-only quality gate)
                    └──────┬───────┘
                           │
                    ┌──────┴───────┐
                    │  implement   ├─→ code + updated tasks.md [X]
                    └──────────────┘

  checklist ──────────────────────── can run any time after specify
```

## Templates

The `templates/` directory contains output format templates for each artifact type:

| Template | Used By | Purpose |
|----------|---------|---------|
| `spec-template.md` | specify | User stories (P1/P2/P3), functional requirements (FR-###), success criteria (SC-###), key entities, assumptions |
| `plan-template.md` | plan | Technical context, constitution check gate, project structure options, complexity tracking |
| `tasks-template.md` | tasks | Phased task breakdown with checkbox format, dependency graph, parallel execution notes |
| `constitution-template.md` | constitution | Principle definitions with placeholders, governance rules, versioning metadata |
| `checklist-template.md` | checklist | Categorized CHK### items with quality dimensions and traceability references |

Templates use `[PLACEHOLDER]` tokens that get replaced with concrete content during generation. They define section hierarchy, required fields, and formatting conventions.

## Example Walkthrough

Here is a condensed example of the full pipeline for building a URL shortener:

### Step 1: Specify

```
User: I want to build a URL shortener with click analytics
```

Produces `specs/001-url-shortener/spec.md`:
- **US1 (P1)**: Users can shorten a URL and get a short link → MVP
- **US2 (P2)**: Users can view click analytics for their links
- **US3 (P3)**: Users can manage (edit/delete) their shortened URLs
- **FR-001**: System MUST generate unique short codes for each URL
- **FR-002**: System MUST redirect short URLs to original URLs
- **SC-001**: Redirect completes in under 500ms for 99% of requests

### Step 2: Plan

```
User: Build with Python 3.12, FastAPI, PostgreSQL, pytest
```

Produces:
- `plan.md` — FastAPI project structure, PostgreSQL schema approach
- `research.md` — Short code generation algorithm comparison
- `data-model.md` — URL, Click, User entities with fields and relationships
- `contracts/api-v1.md` — POST /shorten, GET /{code}, GET /analytics/{code}

### Step 3: Tasks

Produces `tasks.md` with ~25 tasks:
- Phase 1: Setup (project init, dependencies, DB setup)
- Phase 2: Foundational (base models, auth middleware, error handling)
- Phase 3: US1 — URL Shortening (URL model, shortening service, redirect endpoint)
- Phase 4: US2 — Analytics (Click model, analytics service, dashboard endpoint)
- Phase 5: US3 — Management (CRUD endpoints, ownership validation)
- Phase 6: Polish (docs, performance, security hardening)

### Step 4: Implement

Executes all tasks in order, creating the actual code files, marking each task `[X]` as it completes.

## When to Use Each Command

| Situation | Command |
|-----------|---------|
| Starting a new project and want to set ground rules | constitution |
| Have a feature idea, need to structure it | specify |
| Spec exists but has ambiguities | clarify |
| Spec is solid, ready to make technical decisions | plan |
| Plan exists, need an actionable work breakdown | tasks |
| Want a quality check before implementing | analyze |
| Need domain-specific requirements validation | checklist |
| Tasks exist, ready to write code | implement |
| Entering mid-stream with existing artifacts | Check `specs/` and pick up from the right phase |

## Key Concepts

### Spec vs. Plan Separation

The **spec** describes WHAT and WHY — written for business stakeholders, no tech stack, no implementation details. The **plan** describes HOW — tech choices, architecture, file structure. This separation means you can re-plan with a different tech stack without rewriting the spec.

### User Story Independence

Every user story must be independently implementable and testable. US1 should work as an MVP even if US2 and US3 are never built. This enables incremental delivery and reduces risk.

### Constitution Authority

If a constitution exists, it is **non-negotiable** within the analysis scope. Constitution conflicts are always CRITICAL severity. If a principle needs to change, that must happen through an explicit constitution update — never by silently ignoring it.

### Task Format Strictness

The task format (`- [ ] T### [P?] [US#?] Description with file path`) is enforced because it enables:
- Machine-readable progress tracking (checkbox parsing)
- Parallel execution identification (`[P]` markers)
- User story traceability (`[US#]` labels)
- Specific enough for an AI to execute without additional context

### Checklists as "Unit Tests for English"

Checklists validate requirements quality, not implementation correctness. They ask "Is this requirement well-written?" not "Does the code work?" This catches specification gaps before they become implementation bugs.

## Multi-Agent Support

A foundational principle of this skill: **the SDD framework should be understood by any AI coding agent working in the project, not just Claude Code with this skill loaded.**

When spec-kit is first initialized in a project (during the first `specify` or `constitution` phase), it automatically creates or updates four agent instruction files:

| File | Agent(s) |
|------|----------|
| `CLAUDE.md` | Claude Code |
| `.github/copilot-instructions.md` | GitHub Copilot |
| `GEMINI.md` | Gemini CLI |
| `AGENTS.md` | Cross-agent standard (Copilot, Codex, Jules, Junie, Windsurf, Devin, 20+ agents) |

Each file receives an SDD context section (wrapped in `<!-- spec-kit:sdd-context -->` markers) that tells the agent:

- This project uses Spec-Driven Development
- Where to find the `specs/` directory and what each file means
- How to read the task format and execute tasks
- That the constitution is non-negotiable
- How to check for an active feature branch and pick up work

This means:
- A developer using **GitHub Copilot** in VS Code gets SDD-aware suggestions
- A developer using **Gemini CLI** knows to check `specs/` before starting work
- Any agent supporting **AGENTS.md** (the open standard) gets the same context
- **Claude Code** works with or without the spec-kit skill installed — the `CLAUDE.md` instructions provide baseline SDD awareness

The context section is idempotent — subsequent runs detect the marker and replace the existing block rather than duplicating. After the `plan` phase, the section can optionally be enriched with active technology details.

See `references/agent-context.md` for the full implementation details.

## Skill Architecture

```
spec-kit/
  SKILL.md                  ← Orchestrator: workflow overview, routing, directory conventions
  README.md                 ← This file: detailed documentation
  references/               ← Command-level instructions (loaded on demand)
    constitution.md
    specify.md
    clarify.md
    plan.md
    tasks.md
    analyze.md
    checklist.md
    implement.md
    agent-context.md          ← NEW: multi-agent instruction file management
  templates/                ← Output format templates (faithful to spec-kit originals)
    spec-template.md
    plan-template.md
    tasks-template.md
    constitution-template.md
    checklist-template.md
```

The skill uses **progressive disclosure**:
1. **SKILL.md** is always loaded — provides the workflow overview and routing table
2. **Reference files** are loaded on demand when Claude enters a specific phase
3. **Templates** are loaded when generating a specific artifact type

This keeps context usage efficient while providing deep, detailed instructions for each phase.

---

## Source

> Adapted from an external project. See links below for original source and license.

| | |
|---|---|
| **Repository** | [https://github.com/github/spec-kit](https://github.com/github/spec-kit) |
| **Description** | GitHub's Spec-Driven Development toolkit |
| **License** | MIT |
| **Adapted on** | 2026-03-24 |

This skill is a standalone adaptation of spec-kit's core workflow for use as a Claude Code skill. It preserves the SDD methodology, command pipeline, and template formats while removing dependencies on the `specify` CLI tool, shell scripts, extension/preset systems, and multi-agent configuration. All operations are performed directly by Claude Code.
