# Stitch Build Loop Skill

Teaches agents to iteratively build websites using Stitch with an autonomous baton-passing loop pattern.

## Install

```bash
npx skills add google-labs-code/stitch-skills --skill stitch-loop --global
```

## What It Does

Enables continuous, autonomous website development through a "baton" system:

1. Agent reads task from `next-prompt.md`
2. Generates page via Stitch MCP tools
3. Integrates into site structure
4. Writes next task to continue the loop

## Prerequisites

- Stitch MCP Server access
- A `DESIGN.md` file (generate with the `design-md` skill)
- A `SITE.md` file for project context

## Example Prompt

```text
Read my next-prompt.md and generate the page using Stitch, then prepare the next iteration.
```

## Skill Structure

```
stitch-loop/
├── SKILL.md              — Core pattern instructions
├── README.md             — This file
├── resources/
│   ├── baton-schema.md   — Baton file format spec
│   └── site-template.md  — SITE.md/DESIGN.md templates
└── examples/
    ├── next-prompt.md    — Example baton
    └── SITE.md           — Example site constitution
```

## Works With

- **`design-md` skill**: Generate `DESIGN.md` from existing Stitch screens
- **CI/CD**: GitHub Actions can trigger new iterations on push
- **Agent chains**: Dispatch to other agents (Jules, etc.)

## Learn More

See [SKILL.md](./SKILL.md) for complete instructions.

---

## Source

> Extracted from an external repository. See links below for original source and license.

| | |
|---|---|
| **Repository** | [https://github.com/google-labs-code/stitch-skills](https://github.com/google-labs-code/stitch-skills) |
| **Path** | [skills/stitch-loop](https://github.com/google-labs-code/stitch-skills/tree/main/skills/stitch-loop) |
| **Branch** | `main` |
| **Commit** | [`ad0b5cc`](https://github.com/google-labs-code/stitch-skills/commit/ad0b5cc5d5c3569e12a3105b0dee7409c3227e1b) — Merge pull request #36 from google-labs-code/jilin |
| **Author** | J XIA |
| **Commit date** | 2026-03-13T16:00:18-07:00 |
| **Copied on** | 2026-03-27T17:21:34.0944893-05:00 |
