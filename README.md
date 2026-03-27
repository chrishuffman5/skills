# Stitch to React Components Skill

## Install

```bash
npx skills add google-labs-code/stitch-skills --skill react:components --global
```

## Example Prompt

```text
Convert my Landing Page screen in my Podcast Stitch Project to a React component system.
```

## Skill Structure

This repository follows the **Agent Skills** open standard. Each skill is self-contained with its own logic, validation scripts, and design tokens.

```text
skills/react-components/
├── SKILL.md           — Core instructions & workflow
├── package.json       — Validator dependencies
├── scripts/           — Networking & AST validation
├── resources/         — Style guides & API references
└── examples/          — Gold-standard code samples
```

## How it Works

When activated, the agent follows a high-fidelity engineering pipeline:

1. **Retrieval**: Uses a system-level `curl` script to bypass TLS/SNI issues on Google Cloud Storage.
2. **Mapping**: Cross-references Stitch metadata with the local `style-guide.json` to ensure token consistency.
3. **Generation**: Scaffolds components using a strict Atomic Design pattern.
4. **Validation**: Runs an automated AST check using `@swc/core` to prevent hardcoded hex values or missing interfaces.
5. **Audit**: Performs a final self-correction check against a 20-point architecture checklist.

---

## Source

> Extracted from an external repository. See links below for original source and license.

| | |
|---|---|
| **Repository** | [https://github.com/google-labs-code/stitch-skills](https://github.com/google-labs-code/stitch-skills) |
| **Path** | [skills/react-components](https://github.com/google-labs-code/stitch-skills/tree/main/skills/react-components) |
| **Branch** | `main` |
| **Commit** | [`ad0b5cc`](https://github.com/google-labs-code/stitch-skills/commit/ad0b5cc5d5c3569e12a3105b0dee7409c3227e1b) — Merge pull request #36 from google-labs-code/jilin |
| **Author** | J XIA |
| **Commit date** | 2026-03-13T16:00:18-07:00 |
| **Copied on** | 2026-03-27T17:21:34.0944893-05:00 |
