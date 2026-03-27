# Stitch Design Skill

Teaches agents to generate high-fidelity, consistent UI designs and maintain project-level design systems using Stitch.

## Install

```bash
npx skills add google-labs-code/stitch-skills --skill stitch-design --global
```

## What It Does

Enables professional-grade UI/UX design workflows through Stitch MCP:

1. **Prompt Enhancement**: Transforms rough intent into structured, high-fidelity prompts with professional terminology and design system context.
2. **Design System Synthesis**: Analyzes existing Stitch projects to create and maintain a `.stitch/DESIGN.md` "source of truth".
3. **Iterative Generation**: Selects the best generation or editing workflow (`edit_screens`, `generate_variants`) based on user intent.
4. **Asset Management**: Synchronizes remote designs by downloading HTML and screenshots to the project's `.stitch/designs` directory.

## Prerequisites

- Stitch MCP Server access
- A project `projectId` (can be discovered via `list_projects`)

## Example Prompt

```text
Design a premium landing page for a mountain resort with a focus on serene luxury and glassmorphism.
```

## Skill Structure

```
stitch-design/
├── SKILL.md           — Core instructions & Prompt Pipeline
├── README.md          — This file
├── workflows/         — Specialized pipelines (Text-to-UI, Edit, MD)
├── references/        — UI/UX keywords & Technical Mappings
└── examples/          — Gold-standard references (Solace Mindfulness)
```

## Works With

- **`react:components` skill**: Hand-off generated designs for frontend implementation.
- **`stitch-loop` skill**: Provides the `DESIGN.md` context for autonomous building loops.
- **Multi-agent workflows**: Refines prompts before passing design tasks to specialized agents.

## Learn More

See [SKILL.md](./SKILL.md) for complete instructions.

---

## Source

> Extracted from an external repository. See links below for original source and license.

| | |
|---|---|
| **Repository** | [https://github.com/google-labs-code/stitch-skills](https://github.com/google-labs-code/stitch-skills) |
| **Path** | [skills/stitch-design](https://github.com/google-labs-code/stitch-skills/tree/main/skills/stitch-design) |
| **Branch** | `main` |
| **Commit** | [`ad0b5cc`](https://github.com/google-labs-code/stitch-skills/commit/ad0b5cc5d5c3569e12a3105b0dee7409c3227e1b) — Merge pull request #36 from google-labs-code/jilin |
| **Author** | J XIA |
| **Commit date** | 2026-03-13T16:00:18-07:00 |
| **Copied on** | 2026-03-27T17:21:34.0944893-05:00 |
