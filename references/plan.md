# Plan Phase — Implementation Plan Generation

This reference defines how to generate an implementation plan from a feature spec. The plan bridges the WHAT (spec) and the HOW (tasks) by adding technical context, research findings, and design contracts.

## Prerequisites

Before starting this phase, the following MUST exist:
- `specs/<feature-name>/spec.md` — the feature specification (required)
- `specs/constitution.md` — project principles (optional, but checked if present)
- `templates/plan-template.md` — output structure template (required)

## Inputs

1. The feature spec from `specs/<feature-name>/spec.md`
2. The constitution from `specs/constitution.md` (if it exists)
3. The plan template from `templates/plan-template.md`
4. **User-provided technical context** — the user supplies tech stack choices in this phase because the spec deliberately avoids prescribing technology

## Workflow

Execute the following steps in order. Use absolute paths for all file references.

---

### Step 1: Read Inputs

1. Read `specs/<feature-name>/spec.md` in full. Extract all user stories, acceptance criteria, constraints, and assumptions.
2. Read `specs/constitution.md` if it exists. Load all constitutional principles.
3. Read `templates/plan-template.md` to understand the required output structure.

### Step 2: Fill Technical Context

Populate the Technical Context section of the plan from user input. The following fields must be captured:

| Field | Description | Example |
|-------|-------------|---------|
| **Language/Version** | Primary language and version | Python 3.12, TypeScript 5.4 |
| **Primary Dependencies** | Frameworks, libraries, key packages | FastAPI, React 18, Prisma |
| **Storage** | Database, cache, file storage | PostgreSQL 16, Redis, S3 |
| **Testing** | Test framework and strategy | pytest, Vitest, Playwright |
| **Target Platform** | Where it runs | AWS Lambda, Docker, Browser |
| **Project Type** | Category of project | REST API, SPA, CLI tool, Library |
| **Performance Goals** | Latency, throughput, resource limits | p99 < 200ms, 1000 RPS |
| **Constraints** | Hard technical or business limits | No external API calls, HIPAA compliant |
| **Scale/Scope** | Expected data volume, user count | 10K users, 1M records |

**For any field the user has not provided, mark it as `NEEDS CLARIFICATION`.** Do not guess tech stack choices — these must come from the user. You MAY make reasonable inferences (e.g., if the user says "React app" you can infer Browser as the target platform), but always document the inference.

### Step 3: Constitution Check (Gate)

This is a hard gate. If `specs/constitution.md` exists:

1. Compare every planned technical decision against each constitutional principle.
2. If a violation is found:
   - **ERROR**: Stop plan generation. Report the violation clearly:
     ```
     CONSTITUTION VIOLATION: [Principle Name]
     Planned decision: [what the plan proposes]
     Violation: [how it conflicts with the principle]
     ```
   - The ONLY way to proceed past a violation is if the violation is explicitly justified and tracked in the Complexity Tracking table of the plan with a rationale for the exception.
3. If no violations are found, proceed.

If `specs/constitution.md` does not exist, skip this gate entirely.

### Step 4: Phase 0 — Research

For each of the following categories, generate research findings:

1. **NEEDS CLARIFICATION items** — Research reasonable defaults and present options with trade-offs.
2. **Dependencies** — For each primary dependency, research:
   - Current stable version and compatibility
   - Known limitations or gotchas relevant to this feature
   - Alternative options considered and why the chosen one is preferred
3. **Integrations** — For each external system or service the feature touches:
   - API contracts or protocol requirements
   - Authentication/authorization patterns
   - Error handling and retry strategies

Consolidate all research into `specs/<feature-name>/research.md` using this format for each finding:

```markdown
## [Topic Name]

**Decision:** [What was decided]

**Rationale:** [Why this decision was made]

**Alternatives Considered:**
- [Alternative 1]: [Why rejected]
- [Alternative 2]: [Why rejected]

**Open Questions:** [Any remaining unknowns — omit section if none]
```

### Step 5: Phase 1 — Design & Contracts

Produce three artifacts from the spec and research:

#### 5a. Data Model — `specs/<feature-name>/data-model.md`

Extract every entity mentioned or implied by the spec's user stories and acceptance criteria. For each entity:

- Name and description
- Fields/properties with types
- Relationships to other entities (one-to-many, many-to-many, etc.)
- Constraints (unique, required, indexed, etc.)
- Which user stories reference this entity

Use the notation appropriate for the chosen storage technology (e.g., SQL-style for relational databases, document-style for NoSQL).

#### 5b. Interface Contracts — `specs/<feature-name>/contracts/`

Define the interface contracts the system exposes or consumes. Create one file per contract boundary:

- **API contracts**: Endpoints, methods, request/response schemas, status codes, error formats
- **Event contracts**: Event names, payloads, publishers, subscribers
- **Service contracts**: Public method signatures, input/output types, error types

Each contract file should be self-contained and reference the user stories it serves.

#### 5c. Quickstart — `specs/<feature-name>/quickstart.md`

Create a quickstart guide that describes:

- How to set up the development environment for this feature
- How to run the feature end-to-end (happy path)
- Integration test scenarios covering each user story
- Smoke test commands or verification steps

This document is for developers who will implement the tasks. Keep it concrete and actionable.

### Step 6: Post-Design Constitution Re-Check

After design artifacts are complete, run the Constitution Check gate again (same rules as Step 3). The design phase may have introduced decisions not visible in the initial plan. If new violations are found, ERROR with the same format.

### Step 7: Write the Plan

Using the structure from `templates/plan-template.md`, write the full plan to `specs/<feature-name>/plan.md`. The plan must include:

- Technical Context table (from Step 2)
- Architecture overview derived from the design artifacts
- Complexity Tracking table listing any constitutional exceptions with justifications
- References to all generated artifacts (research, data model, contracts, quickstart)
- Risk assessment noting any NEEDS CLARIFICATION items that remain unresolved

### Step 8: Report

After writing all artifacts, report the following to the user:

1. **Branch**: Current git branch name
2. **Plan path**: Absolute path to the generated plan
3. **Generated artifacts**: List of all files created or updated during this phase, with absolute paths

---

## Rules

- **Use absolute paths** in all file operations and all artifact cross-references.
- **ERROR on gate failures** — do not silently skip constitution violations. The user must explicitly acknowledge and justify exceptions.
- **The spec owns the WHAT; the plan owns the HOW** — never modify the spec during this phase. If the spec is ambiguous, document the ambiguity in research.md and make a reasoned decision.
- **Tech stack comes from the user** — the spec deliberately avoids prescribing technology. The user provides tech choices as input to this phase. If they have not provided enough information, mark fields as NEEDS CLARIFICATION and proceed; do not block on missing tech context.
- **Templates are mandatory** — always load and follow `templates/plan-template.md` for the output structure. If the template does not exist, warn the user and use the structure described in this reference as a fallback.
- **Research is not optional** — even if the tech stack seems straightforward, generate research.md. It serves as a decision log for future reference.
- **Design artifacts must trace to user stories** — every entity in the data model and every contract must reference which user stories it supports. Orphaned artifacts indicate a gap between spec and plan.
