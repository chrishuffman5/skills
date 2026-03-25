# Implement Phase — Task Execution

## Purpose

Execute the implementation by processing all tasks defined in `tasks.md`, phase by phase, respecting dependencies and tracking progress. This phase turns the spec and plan into working code.

## Required Inputs

All files live under `specs/<feature-name>/`:

| File | Required | Description |
|------|----------|-------------|
| `tasks.md` | Yes | Task breakdown with phases, dependencies, acceptance criteria |
| `plan.md` | Yes | Architecture and implementation plan |
| `spec.md` | Recommended | Feature specification for reference during implementation |
| `checklists/*.md` | Optional | Requirements quality checklists (gate check if present) |
| Design docs, wireframes, etc. | Optional | Any additional design references in the specs folder |

## Step 1 — Load Context

Read the following files from `specs/<feature-name>/`:

1. `tasks.md` — the primary execution guide
2. `plan.md` — for architectural decisions, tech stack, patterns, and structure
3. `spec.md` — for requirement details and acceptance criteria
4. Any other documents referenced by the plan (design docs, API schemas, etc.)

Build a mental model of the full feature before writing any code.

## Step 2 — Checklist Gate

Check whether `specs/<feature-name>/checklists/` exists and contains any checklist files.

**If checklists exist**, scan every checklist file and check completion status:

- Parse all `- [ ]` (incomplete) and `- [x]` or `- [X]` (complete) items
- Calculate completion percentage for each checklist file

Display a status table:

```markdown
## Checklist Gate

| Checklist | Total | Complete | Incomplete | Status |
|-----------|-------|----------|------------|--------|
| ux.md | 35 | 35 | 0 | PASS |
| security.md | 28 | 20 | 8 | INCOMPLETE |
| api.md | 22 | 22 | 0 | PASS |
```

**If any checklist has incomplete items**, show the table and ask the user:

> Some requirements quality checklists have incomplete items. This may indicate unresolved specification gaps. Would you like to:
> 1. Proceed with implementation anyway
> 2. Review the incomplete checklist items first
> 3. Halt and address the checklist gaps

Wait for the user's response before continuing. Do not proceed automatically.

**If no checklists directory exists**, skip this step silently and continue.

## Step 3 — Project Setup

Before writing feature code, ensure the project's foundational files are in place.

### .gitignore and Ignore Files

Check if a `.gitignore` exists at the project root. If not, create one appropriate for the detected tech stack. If one exists, verify it covers the necessary patterns.

Detect the tech stack from `plan.md` and existing project files, then include comprehensive patterns:

**Node.js / TypeScript:**
```
node_modules/
dist/
build/
.env
.env.*
*.log
.DS_Store
Thumbs.db
coverage/
.nyc_output/
```

**Python:**
```
__pycache__/
*.py[cod]
*$py.class
.venv/
venv/
env/
.env
dist/
build/
*.egg-info/
.pytest_cache/
.coverage
htmlcov/
```

**Java / Kotlin:**
```
target/
build/
.gradle/
*.class
*.jar
*.war
.env
.idea/
*.iml
```

**Go:**
```
bin/
vendor/
*.exe
*.test
*.out
.env
```

**Rust:**
```
target/
Cargo.lock (if library)
.env
```

**General (always include):**
```
.DS_Store
Thumbs.db
*.swp
*.swo
*~
.env
.env.local
.env.*.local
```

Also create or verify other relevant ignore files (`.dockerignore`, `.prettierignore`, etc.) if the tech stack warrants them.

### Project Structure

If the plan specifies a directory structure, create the necessary directories. Do not create placeholder files — only create directories that will be immediately populated by tasks.

## Step 4 — Parse Tasks

Extract the execution plan from `tasks.md`. For each task, capture:

- **Task identifier**: Number, ID, or label
- **Description**: What needs to be done
- **Phase**: Which phase it belongs to
- **Dependencies**: Other tasks that must complete first
- **Parallel flag**: Whether the task is marked `[P]` for parallel execution
- **Acceptance criteria**: How to verify the task is done
- **Requirement traceability**: Which spec requirements this task addresses

Build an execution order that respects:

1. Phase ordering (Phase 1 before Phase 2, etc.)
2. Dependencies within a phase (Task 3 depends on Task 1)
3. Parallel grouping (tasks marked `[P]` within the same phase can run together)

## Step 5 — Execute Phase by Phase

Process each phase in order. Within a phase:

### Sequential Tasks

Execute in dependency order, one at a time. For each task:

1. Announce the task: state the task ID, description, and which requirements it addresses
2. Implement the task fully — write all necessary code, configs, and tests
3. If the task includes tests, follow **TDD order**: write the test first, then write the implementation to make it pass
4. Verify the acceptance criteria are met
5. Mark the task as complete: change `- [ ]` to `- [x]` in `tasks.md`
6. Report completion with a brief summary of what was created or changed

**If a sequential task fails** (cannot be completed due to a blocker, unclear requirement, or external dependency):

- Stop execution immediately
- Report the failure: which task, what went wrong, what is needed to unblock
- Do not proceed to dependent tasks
- Ask the user how to proceed

### Parallel Tasks

Tasks marked with `[P]` that share no dependencies can be executed together. In practice, implement them one after another but do not let a failure in one block the others:

1. Identify the parallel group
2. Execute each task in the group
3. If one parallel task fails, log the failure but continue with the remaining tasks in the group
4. Report all results at the end of the group

### TDD Flow

When a task includes test requirements (or the plan specifies TDD):

1. **Write the test first** — create the test file with test cases that define expected behavior
2. **Verify the test fails** — the test should fail because the implementation does not exist yet
3. **Write the implementation** — create the minimum code to make the test pass
4. **Verify the test passes** — run the test to confirm
5. If additional edge cases are specified, repeat the cycle

### Progress Reporting

After each task completes, provide a brief status update:

```
Task <ID> complete: <one-line summary>
  Files created: <list>
  Files modified: <list>
  Tests: <pass/fail/none>
  Progress: <completed>/<total> tasks in Phase <n>
```

After each phase completes:

```
Phase <n> complete: <completed>/<total> tasks succeeded
  Failures: <list or "none">
  Moving to Phase <n+1>
```

## Step 6 — Completion Validation

After all phases are done, perform a final validation:

### Task Completion Check

Verify every task in `tasks.md` is marked `[x]`. If any remain incomplete, list them and explain why.

### Spec Alignment Check

Review the implemented features against `spec.md`:

- Are all functional requirements addressed?
- Do the implementations match the acceptance criteria?
- Are non-functional requirements respected (performance targets, security constraints, etc.)?

Report any gaps between the spec and what was implemented.

### Test Verification

If tests exist, run the full test suite and report results:

```
## Test Results

- Total tests: <n>
- Passed: <n>
- Failed: <n>
- Skipped: <n>
```

If any tests fail, investigate and fix before reporting completion. If a fix is not possible, report the failure with details.

### Final Summary

```markdown
## Implementation Complete — <feature-name>

### Phases
- Phase 1: <n>/<n> tasks complete
- Phase 2: <n>/<n> tasks complete
- ...

### Files Created
<list of all new files>

### Files Modified
<list of all modified files>

### Test Coverage
<summary of test results>

### Known Issues
<any unresolved items, or "None">

### Spec Coverage
<percentage of requirements addressed, any gaps>
```

## Reminders

- Always read and understand the full context (spec, plan, tasks) before writing code.
- Follow the architecture and patterns specified in `plan.md`. Do not invent new patterns unless the plan is silent on a topic.
- Mark tasks complete in `tasks.md` as you go — this is the source of truth for progress.
- If a requirement is ambiguous, check the spec first, then ask the user. Do not guess.
- Respect the phase boundaries. Do not skip ahead even if a later task seems simple.
- If the plan specifies specific libraries, frameworks, or versions, use exactly those. Do not substitute alternatives without user approval.
- Keep commits logical — one task or one closely related group of changes per commit if the user is committing along the way.
