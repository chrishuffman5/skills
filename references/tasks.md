# Tasks Phase — Actionable Task Breakdown

This reference defines how to generate an actionable, dependency-ordered task breakdown from the implementation plan and supporting artifacts. The task list is the final planning artifact before implementation begins.

## Prerequisites

Before starting this phase, the following MUST exist:
- `specs/<feature-name>/plan.md` — the implementation plan (required)
- `specs/<feature-name>/spec.md` — the feature specification (required)
- `templates/tasks-template.md` — output structure template (required)

The following are optional but will improve task quality if present:
- `specs/<feature-name>/data-model.md` — entity definitions
- `specs/<feature-name>/contracts/` — interface contracts
- `specs/<feature-name>/research.md` — research findings
- `specs/<feature-name>/quickstart.md` — integration/test scenarios

## Inputs

1. Read `specs/<feature-name>/plan.md` in full — this is the primary source for technical decisions and architecture.
2. Read `specs/<feature-name>/spec.md` in full — user stories and acceptance criteria drive the task organization.
3. Read `templates/tasks-template.md` for the required output structure.
4. Read all optional artifacts listed above if they exist.

## Workflow

Execute the following steps in order. Use absolute paths for all file references.

---

### Step 1: Read All Inputs

Load every artifact listed above. Build a mental map of:
- All user stories and their priority (P1, P2, P3 from the spec)
- All entities from the data model and which user stories they serve
- All interface contracts and which user stories they serve
- All technical decisions from the plan
- All setup/infrastructure requirements

### Step 2: Map Sources to User Stories

Before generating tasks, create an internal mapping:

| Source | Item | Maps to User Story |
|--------|------|--------------------|
| spec.md | User Story: "As a user, I can..." | US1 |
| data-model.md | Entity: User | US1, US3 |
| contracts/ | POST /api/users | US1 |
| plan.md | Auth middleware setup | Setup (shared) |

Items that serve multiple user stories or don't belong to any specific story go into Setup (Phase 1) or Foundational (Phase 2).

### Step 3: Generate Tasks

Organize tasks into phases using the structure defined below. Every single task MUST follow the required format.

---

## Task Format

**CRITICAL: Every task MUST follow this exact format. No exceptions.**

```
- [ ] [TaskID] [P?] [Story?] Description with file path
```

### Format Components

| Component | Required | Description |
|-----------|----------|-------------|
| `- [ ]` | YES | Markdown checkbox. Every task must have one. |
| `[TaskID]` | YES | Sequential identifier: T001, T002, T003, ... |
| `[P]` | CONDITIONAL | Include ONLY if the task is parallelizable (works on a different file from neighboring tasks and has no dependency on incomplete tasks). Omit if the task must be done sequentially. |
| `[Story]` | CONDITIONAL | Include for tasks in user story phases (US1, US2, etc.). Omit for Setup, Foundational, and Polish phases. |
| Description | YES | Clear, specific action. MUST include the exact file path being created or modified. |

### Good Examples

```markdown
- [ ] [T001] Initialize project with `npm init` in `src/`
- [ ] [T002] [P] Create database schema in `src/db/schema.prisma`
- [ ] [T003] [P] Create environment config in `src/config/env.ts`
- [ ] [T004] [US1] Create User model in `src/models/user.ts`
- [ ] [T005] [P] [US1] Create email validation utility in `src/utils/validate-email.ts`
- [ ] [T006] [US1] Create user registration endpoint in `src/routes/auth/register.ts`
- [ ] [T007] [US1] Write integration test for registration flow in `tests/integration/register.test.ts`
- [ ] [T008] [P] [US2] Create dashboard page component in `src/pages/dashboard.tsx`
```

### Bad Examples — DO NOT generate tasks like these

```markdown
# BAD: Missing checkbox
[T001] Create user model

# BAD: Missing TaskID
- [ ] Create user model in `src/models/user.ts`

# BAD: Missing file path
- [ ] [T001] [US1] Implement user registration

# BAD: Too vague
- [ ] [T001] [US1] Set up the backend

# BAD: Multiple files in one task (split into separate tasks)
- [ ] [T001] [US1] Create user model in `src/models/user.ts` and user service in `src/services/user.ts`

# BAD: [P] on a task that depends on the previous task
- [ ] [T005] [P] [US1] Create user service in `src/services/user.ts`  (depends on T004 user model)
- [ ] [T006] [P] [US1] Create user controller using user service in `src/routes/user.ts`
```

**Rules for the `[P]` marker:**
- A task is parallelizable ONLY if it operates on a different file AND has zero dependencies on incomplete tasks within the same phase.
- When in doubt, omit `[P]`. False parallelism is worse than missed parallelism.

---

## Phase Structure

Organize all tasks into the following phase structure:

### Phase 1: Setup

Project initialization and scaffolding. These tasks create the project skeleton and have no user story association.

- Project init (package.json, go.mod, pyproject.toml, etc.)
- Directory structure creation
- Linter/formatter configuration
- CI/CD pipeline skeleton
- Environment configuration files

Tasks in this phase do NOT get a `[Story]` tag.

### Phase 2: Foundational

Blocking prerequisites that MUST complete before any user story work begins. These are shared infrastructure components.

- Database connection and migration setup
- Authentication/authorization middleware
- Shared utilities (logging, error handling, validation)
- Base classes, interfaces, or types used across stories
- Third-party service client setup

Tasks in this phase do NOT get a `[Story]` tag.

**CRITICAL: Phase 2 MUST be fully complete before any Phase 3+ work begins.** If a user story task depends on a foundational component, that component belongs in Phase 2, not in the story phase.

### Phase 3+: User Story Phases

One phase per user story, ordered by priority from the spec (P1 first, then P2, then P3). Within each user story phase, order tasks as follows:

1. **Tests** (if testing was explicitly requested by the user) — write test files first
2. **Models** — data models and types specific to this story
3. **Services** — business logic and service layer
4. **Endpoints / UI** — API routes, pages, CLI commands
5. **Integration** — wiring everything together, integration tests

Each user story phase MUST be independently testable after completion. A developer should be able to finish Phase 3 (US1) and verify it works before starting Phase 4 (US2).

Tasks in these phases MUST have a `[Story]` tag (US1, US2, etc.).

### Final Phase: Polish & Cross-Cutting Concerns

Non-functional work that applies across the entire feature:

- Performance optimization
- Security hardening
- Documentation (API docs, README updates)
- Logging and monitoring
- Error handling improvements
- Code cleanup and refactoring

Tasks in this phase do NOT get a `[Story]` tag.

---

## Tests Are Optional

**Only include test tasks if the user has explicitly requested tests.** Check:
- Did the user say "include tests", "with tests", "TDD", or similar?
- Does the plan specify a testing strategy?
- Does the spec mention testing requirements?

If none of these are true, omit all test tasks. Do not assume tests are wanted.

If tests ARE requested, place them first within each user story phase (test-first approach).

---

## Dependency Graph

After listing all tasks, include a dependency section that shows which tasks block which. Use this format:

```markdown
## Dependencies

T001 → T004, T005 (project init must complete before model work)
T004 → T006 (user model must exist before user service)
T006 → T007 (user service must exist before registration endpoint)
```

Only list direct dependencies, not transitive ones.

---

### Step 4: Write the Task List

Using the structure from `templates/tasks-template.md`, write the complete task list to `specs/<feature-name>/tasks.md`. If the template does not exist, warn the user and use the structure described in this reference as a fallback.

### Step 5: Report

After writing the task file, report the following summary to the user:

1. **Total task count**: Number of tasks generated
2. **Count per story**: How many tasks each user story received
3. **Parallel opportunities**: How many tasks are marked `[P]` and which phases have the most parallelism
4. **Suggested MVP scope**: Which user story phases constitute a minimum viable feature (typically all P1 stories)
5. **Output path**: Absolute path to the generated tasks file

---

## Rules

- **Use absolute paths** in all file operations.
- **Every task MUST have a checkbox, a TaskID, and a file path.** No exceptions. If you cannot identify a specific file for a task, the task is too vague — split it or make it more specific.
- **One file per task.** If a task touches multiple files, split it into multiple tasks.
- **Templates are mandatory** — always load and follow `templates/tasks-template.md` for the output structure. If the template does not exist, warn the user and use the structure described in this reference as a fallback.
- **User stories from the spec are the primary organizer.** Tasks that cannot be traced to a user story belong in Setup, Foundational, or Polish phases.
- **Phase 2 is a hard boundary.** No user story task may begin until all foundational tasks are complete. If you discover a dependency during task generation that should be foundational, move it to Phase 2.
- **Sequential IDs across all phases.** T001 starts in Phase 1 and the numbering continues through all phases without resetting. The final task has the highest number.
- **Parallelism is opt-in.** Only mark a task `[P]` if you are confident it can be done simultaneously with its neighbors. The default is sequential.
- **Do not modify any input artifacts.** This phase is read-only on spec.md, plan.md, data-model.md, contracts/, research.md, and quickstart.md.
- **Tests are optional.** Never include test tasks unless the user explicitly requested them.
