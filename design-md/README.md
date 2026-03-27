# Stitch Design System Documentation Skill

## Install

```bash
npx skills add google-labs-code/stitch-skills --skill design-md --global
```

## Example Prompt

```text
Analyze my Furniture Collection project's Home screen and generate a comprehensive DESIGN.md file documenting the design system.
```

## Skill Structure

This repository follows the **Agent Skills** open standard. Each skill is self-contained with its own logic, workflow, and reference materials.

```text
design-md/
├── SKILL.md           — Core instructions & workflow
├── examples/          — Sample DESIGN.md outputs
└── README.md          — This file
```

## How it Works

When activated, the agent follows a structured design analysis pipeline:

1. **Retrieval**: Uses the Stitch MCP Server to fetch project screens, HTML code, and design metadata.
2. **Extraction**: Identifies design tokens including colors, typography, spacing, and component patterns.
3. **Translation**: Converts technical CSS/Tailwind values into descriptive, natural design language.
4. **Synthesis**: Generates a comprehensive DESIGN.md following the semantic design system format.
5. **Alignment**: Ensures output follows Stitch Effective Prompting Guide principles for optimal screen generation.

---

## Source

> Extracted from an external repository. See links below for original source and license.

| | |
|---|---|
| **Repository** | [https://github.com/google-labs-code/stitch-skills](https://github.com/google-labs-code/stitch-skills) |
| **Path** | [skills/design-md](https://github.com/google-labs-code/stitch-skills/tree/main/skills/design-md) |
| **Branch** | `main` |
| **Commit** | [`ad0b5cc`](https://github.com/google-labs-code/stitch-skills/commit/ad0b5cc5d5c3569e12a3105b0dee7409c3227e1b) — Merge pull request #36 from google-labs-code/jilin |
| **Author** | J XIA |
| **Commit date** | 2026-03-13T16:00:18-07:00 |
| **Copied on** | 2026-03-27T17:21:34.0944893-05:00 |
