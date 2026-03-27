# Stitch Enhance Prompt Skill

## Install

```bash
npx skills add google-labs-code/stitch-skills --skill enhance-prompt --global
```

## Example Prompt

```text
Enhance my prompt "make me a login page" for better Stitch generation results.
```

## Skill Structure

This repository follows the **Agent Skills** open standard. Each skill is self-contained with its own logic, workflow, and reference materials.

```text
enhance-prompt/
├── SKILL.md           — Core instructions & workflow
├── references/        — UI/UX vocabulary and adjective palettes
└── README.md          — This file
```

## How it Works

When activated, the agent follows a prompt enhancement pipeline:

1. **Assessment**: Evaluates the input for missing elements (platform, structure, visual style, colors).
2. **DESIGN.md Check**: Looks for an existing design system to inject; recommends creating one if missing.
3. **Enhancement**: Applies UI/UX keywords, vibe adjectives, and structured page sections.
4. **Formatting**: Outputs a Stitch-optimized prompt with design system block and numbered structure.
5. **Delivery**: Returns enhanced text for user review, with optional file output.

---

## Source

> Extracted from an external repository. See links below for original source and license.

| | |
|---|---|
| **Repository** | [https://github.com/google-labs-code/stitch-skills](https://github.com/google-labs-code/stitch-skills) |
| **Path** | [skills/enhance-prompt](https://github.com/google-labs-code/stitch-skills/tree/main/skills/enhance-prompt) |
| **Branch** | `main` |
| **Commit** | [`ad0b5cc`](https://github.com/google-labs-code/stitch-skills/commit/ad0b5cc5d5c3569e12a3105b0dee7409c3227e1b) — Merge pull request #36 from google-labs-code/jilin |
| **Author** | J XIA |
| **Commit date** | 2026-03-13T16:00:18-07:00 |
| **Copied on** | 2026-03-27T17:21:34.0944893-05:00 |
