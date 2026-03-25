# Sensei

> "A true master teaches not by telling, but by refining." - The Skill Sensei

Sensei automates the improvement of [Agent Skills](https://agentskills.io) frontmatter compliance using the [Ralph loop pattern](https://github.com/soderlund/ralph) — iteratively improving skills until they reach Medium-High compliance with all tests passing.

## Quick Start

```
Run sensei on code-review
Run sensei on code-review, data-transform
Run sensei on all Low-adherence skills
Run sensei on all skills
```

## What It Does

1. **Read** - Load the skill's current state and token count
2. **Score** - Evaluate frontmatter compliance against the [agentskills.io spec](https://agentskills.io/specification)
3. **Improve** - Add triggers, optimize description
4. **Verify** - Run tests to ensure changes work
5. **Validate References** - Check markdown links are valid
6. **Check Tokens** - Analyze token usage, gather suggestions
7. **Summary** - Display before/after with suggestions
8. **Prompt** - Ask user: Commit, Create Issue, or Skip?
9. **Repeat** - Until target score reached

## Target: Medium-High Adherence

| Criteria | Requirement |
|----------|-------------|
| Description length | > 150 characters, ≤ 60 words |
| Trigger phrases | Has `WHEN:` with distinctive quoted phrases |
| Format | Inline double-quoted string (no `>-` or `\|`) |
| Token budget | SKILL.md < 500 tokens (soft limit) |

## Reference Documentation

- [SCORING.md](references/SCORING.md) - Detailed scoring criteria
- [LOOP.md](references/LOOP.md) - Ralph loop workflow details
- [EXAMPLES.md](references/EXAMPLES.md) - Before/after examples
- [TOKEN-INTEGRATION.md](references/TOKEN-INTEGRATION.md) - Token budget integration

## References

- [Ralph (loop pattern)](https://github.com/soderlund/ralph) - Original Ralph loop implementation
- [Agent Skills Specification](https://agentskills.io/specification) - Official spec
- [Anthropic Skills Best Practices](https://support.anthropic.com/en/articles/12512198-how-to-create-custom-skills) - Writing guidance

---

## Source

> Originally derived from the Microsoft GitHub-Copilot-for-Azure project. Generalized to work with any skill set.

| | |
|---|---|
| **Original Repository** | [https://github.com/microsoft/GitHub-Copilot-for-Azure](https://github.com/microsoft/GitHub-Copilot-for-Azure) |
| **Original Path** | [.github/skills/sensei](https://github.com/microsoft/GitHub-Copilot-for-Azure/tree/main/.github/skills/sensei) |
| **Branch** | `main` |
| **Commit** | [`6b24a42`](https://github.com/microsoft/GitHub-Copilot-for-Azure/commit/6b24a426316460d359416b10278d607c792d0b7e) |
| **Author** | Julia Yin |
| **Commit date** | 2026-03-24T17:54:24-07:00 |
| **Copied on** | 2026-03-24T21:52:51.6674343-05:00 |
