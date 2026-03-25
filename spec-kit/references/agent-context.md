# Agent Context: Updating AI Coding Agent Instruction Files

When the spec-kit framework is initialized in a project (during the first `specify` or `constitution` phase), create or update agent instruction files so that **any AI coding agent** working in the project immediately understands the spec-driven development workflow and knows to look at the `specs/` directory.

This step ensures that even without the spec-kit skill loaded, agents reading project-level instructions will understand the framework.

---

## Target Files

Create or update all four of these files. If a file already exists, **append** the SDD context section. If it does not exist, **create** it with the SDD context as the core content.

| File | Agent | Create if missing? |
|------|-------|--------------------|
| `CLAUDE.md` (project root) | Claude Code | Yes |
| `.github/copilot-instructions.md` | GitHub Copilot | Yes (create `.github/` dir if needed) |
| `GEMINI.md` (project root) | Gemini CLI | Yes |
| `AGENTS.md` (project root) | Cross-agent standard (Copilot, Codex, Jules, Junie, Windsurf, 20+ agents) | Yes |

---

## When to Run

Trigger agent context updates at these points in the workflow:

1. **After the first `specify`** — when the `specs/` directory is created for the first time
2. **After `constitution`** — when project principles are established or updated
3. **After `plan`** — when the tech stack is chosen (update the "active technologies" section if applicable)

Before updating, check if the SDD context section already exists in each file (search for the marker comment `<!-- spec-kit:sdd-context -->`). If found, **replace** the existing section. If not found, **append** it.

---

## SDD Context Section

The following markdown block should be inserted into each agent instruction file. Adapt the formatting slightly for each agent (see per-agent notes below), but keep the content identical.

Use `<!-- spec-kit:sdd-context -->` as start marker and `<!-- /spec-kit:sdd-context -->` as end marker so it can be found and replaced on subsequent updates.

```markdown
<!-- spec-kit:sdd-context -->
## Spec-Driven Development

This project uses **Spec-Driven Development (SDD)** — specifications are the primary artifact, code is their expression. All feature planning, requirements, and task breakdowns live in the `specs/` directory.

### Directory Structure

```
specs/
  constitution.md                ← Project principles (non-negotiable rules governing all work)
  <feature-name>/
    spec.md                      ← Feature specification (WHAT and WHY, no tech details)
    plan.md                      ← Implementation plan (tech stack, architecture, file structure)
    research.md                  ← Technical research findings
    data-model.md                ← Entity definitions and relationships
    contracts/                   ← Interface contracts (API specs, CLI schemas, etc.)
    quickstart.md                ← Integration and test scenarios
    tasks.md                     ← Actionable task breakdown (dependency-ordered, by user story)
    checklists/                  ← Requirements quality checklists
```

### Before Starting Any Work

1. **Check `specs/constitution.md`** — if it exists, all work must comply with its principles. Constitution violations are always critical.
2. **Check for an active feature** — look for the feature directory matching the current git branch in `specs/`. Read `spec.md` first to understand the requirements, then `plan.md` for technical approach, then `tasks.md` for what to implement.
3. **Follow the task list** — tasks in `tasks.md` are dependency-ordered. Execute them in phase order. Mark completed tasks as `[X]`. Tasks marked `[P]` can run in parallel.

### Task Format

Tasks follow this strict format:
```
- [ ] T001 [P] [US1] Description with exact file path
```
- `T001` = sequential task ID
- `[P]` = parallelizable (optional)
- `[US1]` = user story label (in story phases)

### Key Principles

- **Specs define WHAT and WHY** — no implementation details in spec.md
- **Plans define HOW** — tech stack, architecture, file structure in plan.md
- **Each user story is independently testable** — US1 works as MVP even without US2/US3
- **Constitution is non-negotiable** — if it exists, everything must comply
<!-- /spec-kit:sdd-context -->
```

---

## Per-Agent Notes

### CLAUDE.md

Append the SDD context section as-is. If creating a new file, add a minimal header first:

```markdown
# Project Instructions

<!-- spec-kit:sdd-context -->
...
<!-- /spec-kit:sdd-context -->
```

If the file already exists, append after the existing content with a blank line separator.

### .github/copilot-instructions.md

Same content, no changes needed. Create the `.github/` directory if it doesn't exist:

```bash
mkdir -p .github
```

If creating a new file:

```markdown
# Copilot Instructions

<!-- spec-kit:sdd-context -->
...
<!-- /spec-kit:sdd-context -->
```

### GEMINI.md

Same content, no changes needed. If creating a new file:

```markdown
# Project Instructions

<!-- spec-kit:sdd-context -->
...
<!-- /spec-kit:sdd-context -->
```

### AGENTS.md

Same content, no changes needed. If creating a new file:

```markdown
# Agent Instructions

<!-- spec-kit:sdd-context -->
...
<!-- /spec-kit:sdd-context -->
```

---

## Implementation Steps

1. For each target file, check if it exists at the expected path.
2. If it exists, read it and search for `<!-- spec-kit:sdd-context -->`.
   - If the marker is found, replace everything between `<!-- spec-kit:sdd-context -->` and `<!-- /spec-kit:sdd-context -->` (inclusive) with the updated block.
   - If the marker is NOT found, append the block to the end of the file (with a blank line separator).
3. If the file does not exist, create it with a minimal header and the SDD context block.
4. Report to the user which files were created vs. updated.

---

## Update Triggers

When updating agent context after the `plan` phase, you may optionally enrich the SDD context section with project-specific details extracted from `plan.md`:

- **Active technologies** from the Technical Context section (language, dependencies, testing framework)
- **Project structure** from the Project Structure section

Append these as a subsection within the SDD context block:

```markdown
### Active Technologies

- **Language**: Python 3.12
- **Framework**: FastAPI
- **Testing**: pytest
- **Storage**: PostgreSQL
```

This is optional and should only be added after the `plan` phase produces concrete technical decisions.
