---
name: spec-kit
description: Implement spec-driven development (SDD) for any software project. Use this skill whenever the user wants to plan, specify, or systematically build a feature using structured specifications, or when they mention "spec-driven", "spec-kit", "constitution", "feature spec", or want to go from idea to implementation with a structured planning process. Also trigger when the user asks to "specify a feature", "create a plan", "break into tasks", or "analyze consistency" across project artifacts.
---

# Spec-Driven Development

## Overview

Spec-Driven Development inverts the traditional code-first approach: **specifications are the primary artifact, code is its expression**. This skill provides a sequential pipeline that takes a feature from idea to implementation through structured phases:

```
constitution --> specify --> clarify --> plan --> tasks --> analyze --> implement
                                                    \--> checklist (optional, any time after specify)
```

Each phase produces markdown artifacts that feed into the next. All artifacts live under a `specs/` directory in the project root.

## Directory Conventions

When using this skill, organize artifacts as follows:

```
<project-root>/
  specs/
    constitution.md                ← project principles (shared across features)
    <feature-name>/
      spec.md                      ← feature specification
      plan.md                      ← implementation plan
      research.md                  ← tech research findings
      data-model.md                ← entity definitions
      contracts/                   ← interface contracts (API specs, etc.)
      quickstart.md                ← integration/test scenarios
      tasks.md                     ← actionable task breakdown
      checklists/                  ← quality validation checklists
        requirements.md
        ux.md, security.md, etc.
```

## Commands

Each command is detailed in a reference file. Read the relevant reference file before executing that phase.

| Command | Reference File | Purpose |
|---------|---------------|---------|
| **constitution** | `references/constitution.md` | Create/update project principles that govern all work |
| **specify** | `references/specify.md` | Create a feature spec from a natural language description |
| **clarify** | `references/clarify.md` | Interactive Q&A to reduce spec ambiguity (max 5 questions) |
| **plan** | `references/plan.md` | Generate implementation plan with research and design artifacts |
| **tasks** | `references/tasks.md` | Break the plan into dependency-ordered, actionable tasks |
| **analyze** | `references/analyze.md` | Read-only consistency analysis across spec, plan, and tasks |
| **checklist** | `references/checklist.md` | Generate domain-specific requirements quality checklists |
| **implement** | `references/implement.md` | Execute all tasks from tasks.md phase by phase |
| **agent-context** | `references/agent-context.md` | Create/update AI agent instruction files with SDD context |

## Workflow

### Starting a New Feature

1. **If no constitution exists**, read `references/constitution.md` and create `specs/constitution.md` with project principles.
2. Read `references/specify.md`. Create a feature branch (`git checkout -b <###-feature-name>`), create `specs/<feature-name>/`, and write `spec.md` from the user's description.
3. **Update agent instruction files** — read `references/agent-context.md` and create/update `CLAUDE.md`, `.github/copilot-instructions.md`, `GEMINI.md`, and `AGENTS.md` so any AI agent working in the project understands the SDD framework. This only needs to run once (on first specify) or when the constitution changes.
4. Optionally read `references/clarify.md` and run clarification to tighten the spec.
5. Read `references/plan.md`. The user provides tech stack choices. Generate `plan.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`.
6. Read `references/tasks.md`. Generate `tasks.md` organized by user story.
7. Optionally read `references/analyze.md` for a consistency check before implementation.
8. Read `references/implement.md`. Execute tasks phase by phase, marking each complete.

### Entering Mid-Stream

Users may already have some artifacts. Check what exists in `specs/` and pick up from the appropriate phase. If the user says "plan this feature" and a spec already exists, go straight to the plan phase.

## Key Principles

- **Specify WHAT and WHY, not HOW** — specs are for business stakeholders, plans are for developers
- **Make informed guesses** — don't ask the user about every detail; use reasonable defaults and document assumptions
- **Constitution is non-negotiable** — if it exists, all artifacts must comply with it
- **Each user story must be independently testable** — the task breakdown enables incremental delivery
- **Templates guide structure** — always use the templates in `templates/` for output format
- **Agent-aware by default** — when the SDD framework is introduced to a project, update AI agent instruction files (`CLAUDE.md`, `.github/copilot-instructions.md`, `GEMINI.md`, `AGENTS.md`) so that any coding agent immediately understands the `specs/` directory and the SDD workflow. This ensures the framework works whether or not this skill is loaded. See `references/agent-context.md` for details.

## Templates

Output templates are in the `templates/` directory. Always load the relevant template before generating an artifact to ensure consistent structure:

- `templates/spec-template.md` — feature specification structure
- `templates/plan-template.md` — implementation plan structure
- `templates/tasks-template.md` — task list structure and format
- `templates/constitution-template.md` — constitution structure
- `templates/checklist-template.md` — checklist structure
