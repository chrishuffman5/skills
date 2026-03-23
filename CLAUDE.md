# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo manages multiple skills (for Claude Code, GitHub Copilot, Gemini, etc.) using a **branch-per-skill** model. Each skill is authored as a folder on `main`, and a CI/CD pipeline automatically publishes it to a dedicated branch where the branch name matches the skill name.

## Architecture

```
main branch:
  CLAUDE.md
  .gitignore
  LICENSE
  .github/workflows/    ← CI/CD that creates/updates skill branches
  <skill-name>/         ← each skill is a folder in the repo root
    SKILL.md            ← skill definition (required)
    references/         ← optional supporting reference material
    scripts/            ← optional supporting scripts
    ...

skill branch (e.g. "skill-creator"):
  SKILL.md              ← skill definition (at branch root)
  references/
  scripts/
  ...
```

**Key rule:** On a skill branch, the `SKILL.md` and all supporting files sit at the **root** of the branch — not nested inside a subfolder. The CI/CD pipeline handles this transformation automatically: it takes the contents of `<skill-name>/` from main and places them at the root of the `<skill-name>` branch.

## Workflow: Creating a New Skill

1. **Create a folder** on `main` named after the skill (e.g. `skill-creator/`).
2. **Add a `SKILL.md`** inside that folder along with any supporting files (`references/`, `scripts/`, etc.).
3. **Commit and push to `main`**.
4. The GitHub Actions pipeline (`.github/workflows/publish-skill.yml`) detects the new or updated skill folder and automatically:
   - Creates the skill branch if it doesn't exist (as an orphan branch)
   - Copies the folder contents to the root of that branch
   - Commits and pushes the branch

No manual branch creation is needed.

## How Users Install a Skill

Clone a single skill branch directly into the skills directory:

```bash
git clone https://github.com/chrishuffman5/skills --branch <skill-name> <skill-name>
```

For example, from inside `.claude/skills/`:
```bash
git clone https://github.com/chrishuffman5/skills --branch skill-creator skill-creator
```

This creates `.claude/skills/skill-creator/` with `SKILL.md` at its root.

## Branch Conventions

- `main` — source of truth for all skills (as folders), repo metadata, CI/CD
- Every other branch — exactly one skill, auto-managed by CI/CD, branch name = skill folder name
- Never manually create or edit skill branches — let the pipeline manage them
- Skill branches are independent — they are not merged into each other or into main

## Reserved Root Entries

These names at the root of `main` are **not** skill folders and are excluded by the pipeline:

- `.git/`, `.github/`, `.gitignore`
- `CLAUDE.md`, `LICENSE`, `README.md`
