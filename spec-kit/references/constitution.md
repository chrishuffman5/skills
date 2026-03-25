# Constitution Workflow

This reference teaches how to create or update a project constitution — a governance document containing non-negotiable principles that all artifacts must comply with.

## Workflow

### Step 1: Check for Existing Constitution

Check if `specs/constitution.md` exists in the project root.

- If it does NOT exist, load `templates/constitution-template.md` as the starting point.
- If it DOES exist, load the current constitution for amendment.

### Step 2: Identify Placeholder Tokens

Scan the template (or existing constitution) for all placeholder tokens matching the pattern `[ALL_CAPS_IDENTIFIER]` (e.g., `[PROJECT_NAME]`, `[PRINCIPLE_1_NAME]`, `[GOVERNANCE_RULES]`). Collect every unique token into a checklist so none are missed during replacement.

### Step 3: Collect and Derive Values

For each placeholder token, resolve its value from one of the following sources (in priority order):

1. **Explicit user input** — the user directly provides the value in conversation.
2. **Repository context** — derive from README, docs, existing code, package manifests, or other project files.
3. **Conversation context** — infer from the broader discussion, stated goals, or domain knowledge.

If a value cannot be confidently resolved, ask the user rather than guessing.

### Step 4: Respect the User's Scope

The template ships with five principle slots and additional sections. The user may want fewer or more principles and sections than the template provides. Respect their request:

- Remove unused principle sections entirely rather than leaving them blank.
- Add new principle sections following the same heading format if the user needs more.
- The same applies to the optional sections (`[SECTION_2_NAME]`, `[SECTION_3_NAME]`, etc.) — add, remove, or rename as the user directs.

### Step 5: Replace Every Placeholder with Concrete Text

Each Principle section must contain:

- **A name**: short, declarative title (the `###` heading).
- **A description**: one or more paragraphs stating non-negotiable rules. Use declarative, testable language. Avoid vague "should" phrasing — prefer "MUST", "MUST NOT", "ALWAYS", "NEVER" where appropriate.
- **An explicit rationale**: a sentence or short paragraph explaining *why* the principle exists, so future readers understand the intent behind the rule.

Example structure for a principle:

```markdown
### Dependency Minimalism

Every third-party dependency MUST solve a problem that would take more than one day to implement in-house. Dependencies MUST be evaluated for maintenance health (last commit < 6 months, > 100 stars or equivalent adoption signal) before adoption.

**Rationale**: Reducing external dependencies shrinks the attack surface, lowers upgrade burden, and keeps the build reproducible. Past incidents traced to abandoned transitive dependencies motivate this constraint.
```

### Step 6: Version Using Semver

Apply semantic versioning to the constitution:

- **MAJOR** bump: incompatible changes — removing a principle, redefining a principle's meaning in a breaking way.
- **MINOR** bump: additive changes — new principles, new sections.
- **PATCH** bump: clarifications, typo fixes, rationale expansions that do not change the rule itself.

For a brand-new constitution, start at `1.0.0`.

### Step 7: Dates in ISO Format

All dates in the constitution MUST use `YYYY-MM-DD` format (e.g., `2026-03-24`).

### Step 8: Generate a Sync Impact Report

Insert an HTML comment block at the very top of `specs/constitution.md` (before the `#` title heading) containing a Sync Impact Report:

```markdown
<!--
SYNC IMPACT REPORT
Version change: 1.0.0 → 1.1.0
Bump type: MINOR

Modified principles: none
Added principles: Observability First
Removed principles: none

Templates requiring review:
- specs/billing/spec.md — references removed principle
- specs/auth/plan.md — may conflict with new Observability principle
-->
```

For the initial creation (no prior version), the report notes `Version change: none → 1.0.0` and lists all principles as "Added".

### Step 9: Write to `specs/constitution.md`

Write the completed constitution to `specs/constitution.md` in the project root. Create the `specs/` directory if it does not exist.

### Step 10: Output Summary

After writing, output a summary to the user containing:

- The new version number.
- The bump rationale (why MAJOR/MINOR/PATCH).
- A suggested commit message, e.g.: `docs(constitution): add project constitution v1.0.0`.

## Constitution Check Propagation

After creating or updating the constitution, scan for any existing spec, plan, or task files in `specs/` subdirectories:

- Look for files named `spec.md`, `plan.md`, `tasks.md` in any subdirectory of `specs/`.
- For each file found, check whether its content aligns with the updated principles.
- Flag any issues where an existing artifact appears to violate or contradict a constitution principle.
- Report flagged issues to the user with the file path, the relevant principle, and a brief explanation of the potential conflict.

Do NOT automatically modify these files. Only report; let the user decide how to resolve.

## Update Agent Instruction Files

After creating or updating the constitution, read `references/agent-context.md` and create/update the agent instruction files (`CLAUDE.md`, `.github/copilot-instructions.md`, `GEMINI.md`, `AGENTS.md`). This ensures all AI coding agents in the project are aware of the SDD framework and the `specs/` directory.

If the `<!-- spec-kit:sdd-context -->` marker already exists in these files, replace the existing block with the updated version. If it does not exist, append it.

## Formatting Rules

- Use Markdown headings consistent with the template structure.
- No remaining unexplained bracket tokens (`[LIKE_THIS]`) in the final output. Every placeholder must be replaced or the section must be removed.
- Principles must be declarative and testable. Avoid vague "should" language — use "MUST", "MUST NOT", "ALWAYS", "NEVER" to make compliance unambiguous.
- Include a **Rationale** line or paragraph for every principle so the "why" is never lost.
