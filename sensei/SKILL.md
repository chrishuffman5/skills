---
name: sensei
description: "**WORKFLOW SKILL** — Iteratively improve skill frontmatter compliance using the Ralph loop pattern. WHEN: \"run sensei\", \"sensei help\", \"improve skill\", \"fix frontmatter\", \"skill compliance\", \"frontmatter audit\", \"score skill\", \"check skill quality\". Runs scoring checks, validates triggers, and tracks token budgets."
license: MIT
metadata:
  author: Microsoft
  version: "2.0.0"
---

# Sensei

> "A true master teaches not by telling, but by refining." - The Skill Sensei

Automates skill frontmatter improvement using the [Ralph loop pattern](https://github.com/soderlund/ralph) — iteratively improving skills until they reach Medium-High compliance with passing tests, then checking token usage and prompting for action.

## Help

When user says "sensei help" or asks how to use sensei, show this:

```
╔══════════════════════════════════════════════════════════════════╗
║  SENSEI - Skill Frontmatter Compliance Improver                  ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  USAGE:                                                          ║
║    Run sensei on <skill-name>              # Single skill        ║
║    Run sensei on <skill-name> --quick      # Skip deep checks    ║
║    Run sensei on <skill1>, <skill2>, ...   # Multiple skills     ║
║    Run sensei on all Low-adherence skills  # Batch by score      ║
║    Run sensei on all skills                # All skills          ║
║                                                                  ║
║  EXAMPLES:                                                       ║
║    Run sensei on code-review                                     ║
║    Run sensei on data-transform --quick                          ║
║    Run sensei on code-review, api-docs                           ║
║    Run sensei on all Low-adherence skills                        ║
║                                                                  ║
║  WHAT IT DOES:                                                   ║
║    1. READ      - Load skill's SKILL.md and token count          ║
║    2. SCORE     - Check compliance (Low/Medium/Medium-High/High) ║
║    3. SCAFFOLD  - Create tests from template if missing          ║
║    4. IMPROVE   - Add WHEN: triggers (cross-model optimized)     ║
║    5. TEST      - Run tests, fix if needed                       ║
║    6. REFERENCES- Validate markdown links                        ║
║    7. TOKENS    - Check token budget, gather suggestions         ║
║    8. SUMMARY   - Show before/after with suggestions             ║
║    9. PROMPT    - Ask: Commit, Create Issue, or Skip?            ║
║   10. REPEAT    - Until Medium-High score + tests pass           ║
║                                                                  ║
║  TARGET SCORE: Medium-High                                       ║
║    ✓ Description > 150 chars, ≤ 60 words                         ║
║    ✓ Has "WHEN:" trigger phrases (preferred)                     ║
║    ✓ No "DO NOT USE FOR:" (risky in multi-skill envs)            ║
║    ✓ SKILL.md < 500 tokens (soft limit)                          ║
║                                                                  ║
║  MORE INFO:                                                      ║
║    See references/ for scoring, loop, and token details          ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

## When to Use

- Improving a skill's frontmatter compliance score
- Adding trigger phrases to skill descriptions
- Batch-improving multiple skills at once
- Auditing and fixing Low-adherence skills

## Invocation Modes

### Single Skill
```
Run sensei on code-review
```

### Multiple Skills
```
Run sensei on code-review, data-transform
```

### By Adherence Level
```
Run sensei on all Low-adherence skills
```

### All Skills
```
Run sensei on all skills
```

## The Ralph Loop

For each skill, execute this loop until score >= Medium-High AND tests pass:

1. **READ** - Load `{skill-name}/SKILL.md`, any tests, and count tokens
2. **SCORE** - Run spec-based compliance check (see [SCORING.md](references/SCORING.md)):
   - Validate `name` per [agentskills.io spec](https://agentskills.io/specification) (no `--`, no start/end `-`, lowercase alphanumeric)
   - Check description length and word count (≤60 words)
   - Check triggers (WHEN: preferred, USE FOR: accepted)
   - Warn on "DO NOT USE FOR:" (risky in multi-skill environments)
   - Preserve optional spec fields (`license`, `metadata`, `allowed-tools`) if present
3. **CHECK** - If score >= Medium-High AND tests pass → go to TOKENS step
4. **SCAFFOLD** - If tests don't exist, create trigger test prompts for the skill
5. **IMPROVE FRONTMATTER** - Add WHEN: triggers (stay under 60 words and 1024 chars)
6. **IMPROVE TESTS** - Update `shouldTriggerPrompts` and `shouldNotTriggerPrompts` to match
7. **VERIFY** - Run trigger tests against the updated description
8. **VALIDATE REFERENCES** - Check that markdown links in skill files are valid and stay within the skill directory
9. **TOKENS** - Check token budget and line count (< 500 lines per spec), gather optimization suggestions
10. **SUMMARY** - Display before/after comparison with unimplemented suggestions
11. **PROMPT** - Ask user: Commit, Create Issue, or Skip?
12. **REPEAT** - Go to step 2 (max 5 iterations per skill)

## Scoring Criteria (Quick Reference)

Sensei validates skills against the [agentskills.io specification](https://agentskills.io/specification). See [SCORING.md](references/SCORING.md) for full details.

| Score | Requirements |
|-------|--------------|
| **Invalid** | Name fails spec validation (consecutive hyphens, start/end hyphen, uppercase, etc.) |
| **Low** | Basic description, no explicit triggers |
| **Medium** | Has trigger keywords/phrases, description > 150 chars, >60 words |
| **Medium-High** | Has "WHEN:" (preferred) or "USE FOR:" triggers, ≤60 words |
| **High** | Medium-High + compatibility field |

**Target: Medium-High** (distinctive triggers, concise description)

> "DO NOT USE FOR:" is **risky in multi-skill environments** (15+ overlapping skills) — causes keyword contamination on fast-pattern-matching models. Safe for small, isolated skill sets. Use positive routing with `WHEN:` for cross-model safety.

**Strongly recommended** (reported as suggestions if missing):
- `license` — identifies the license applied to the skill
- `metadata.version` — tracks the skill version for consumers

## Frontmatter Template

Per the [agentskills.io spec](https://agentskills.io/specification), required and optional fields:

```yaml
---
name: skill-name
description: "[ACTION VERB] [UNIQUE_DOMAIN]. [One clarifying sentence]. WHEN: \"trigger 1\", \"trigger 2\", \"trigger 3\"."
license: MIT
metadata:
  version: "1.0"
# Other optional spec fields — preserve if already present:
# metadata.author: example-org
# allowed-tools: Bash(git:*) Read
---
```

> **IMPORTANT:** Use inline double-quoted strings for descriptions. Do NOT use `>-` folded scalars (incompatible with skills.sh). Do NOT use `|` literal blocks (preserves newlines). Keep total description under 1024 characters and ≤60 words.

> **"DO NOT USE FOR:" carries context-dependent risk.** In multi-skill environments (10+ skills with overlapping domains), anti-trigger clauses introduce the very keywords that cause wrong-skill activation on Claude Sonnet and fast-pattern-matching models. For small, isolated skill sets (1-5 skills), the risk is low. When in doubt, use positive routing with `WHEN:` and distinctive quoted phrases.

## Test Scaffolding

When tests don't exist, create trigger test prompts for the skill:

1. `shouldTriggerPrompts` - 5+ prompts matching new frontmatter triggers
2. `shouldNotTriggerPrompts` - 5+ prompts that should NOT trigger this skill

**Commit Messages:**
```
sensei: improve {skill-name} frontmatter
```

## Constraints

- Max 5 iterations per skill before moving on
- Description must stay under 1024 characters
- SKILL.md should stay under 500 tokens (soft limit)
- Tests must pass before prompting for action
- User chooses: Commit, Create Issue, or Skip after each skill

## Flags

| Flag | Description |
|------|-------------|
| `--quick` | Skip deep checks (reference validation, token analysis) for faster iteration. |

> Skipping deep checks speeds up the loop but may miss issues. Consider running a full pass before final commit.

## Reference Documentation

- [SCORING.md](references/SCORING.md) - Detailed scoring criteria
- [LOOP.md](references/LOOP.md) - Ralph loop workflow details
- [EXAMPLES.md](references/EXAMPLES.md) - Before/after examples
- [TOKEN-INTEGRATION.md](references/TOKEN-INTEGRATION.md) - Token budget integration
