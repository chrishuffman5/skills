# Examples

Before and after examples of frontmatter improvements, including token counts.

## Example 1: code-review (Low → Medium-High)

### Before (Low Adherence)

**SKILL.md frontmatter:**
```yaml
---
name: code-review
description: 'Review code for bugs, style issues, and best practices'
---
```

**Metrics:**
- Score: Low
- Tokens: ~120
- Triggers: 0

**Problems:**
- Only 54 characters — too brief
- No trigger phrases
- Agent doesn't know when to activate

**Trigger tests:**
```javascript
const shouldTriggerPrompts = [
  // Empty - no test coverage
];

const shouldNotTriggerPrompts = [
  'What is the weather today?',
  'Help me write a poem',
];
```

### After (Medium-High Adherence)

**SKILL.md frontmatter:**
```yaml
---
name: code-review
description: "Review code for bugs, security issues, and best practices with actionable feedback. WHEN: \"review this code\", \"code review\", \"check my PR\", \"find bugs in\", \"review pull request\", \"audit this function\", \"is this code safe\"."
---
```

**Metrics:**
- Score: Medium-High
- Tokens: ~350 (under 500 budget)
- Triggers: 7 (WHEN: format)

**Improvements:**
- Informative but concise (under 60 words)
- Uses inline double-quoted string (skills.sh compatible)
- Explicit "WHEN:" trigger phrases with quoted keywords
- No "DO NOT USE FOR:" (avoids keyword contamination)

**Trigger tests:**
```javascript
const shouldTriggerPrompts = [
  'Review this code for potential issues',
  'Can you do a code review on my pull request?',
  'Check my PR for bugs before I merge',
  'Find bugs in this function',
  'Audit this authentication module',
  'Is this code safe from injection attacks?',
];

const shouldNotTriggerPrompts = [
  'What is the weather today?',
  'Help me write a poem',
  'Write unit tests for this function',        // → test-generator
  'Refactor this code to use async/await',      // → code refactoring
  'Explain how this algorithm works',           // → code explanation
  'Deploy my application to production',        // → deployment skill
  'Format this file with prettier',             // → code formatting
];
```

---

## Example 2: data-transform (Low → Medium-High)

### Before (Low Adherence)

**SKILL.md frontmatter:**
```yaml
---
name: data-transform
description: 'Transform data between formats like CSV, JSON, XML, and Parquet for ETL pipelines and data processing.'
---
```

**Problems:**
- Catalog-style description (lists formats, not actions)
- No trigger phrases
- Overlaps with file-converter, etl-pipeline

### After (Medium-High Adherence)

**SKILL.md frontmatter:**
```yaml
---
name: data-transform
description: "Transform and convert data between formats for ETL pipelines and data processing workflows. WHEN: \"convert CSV to JSON\", \"transform this data\", \"parse XML to\", \"ETL pipeline\", \"reshape this dataset\", \"data migration\", \"convert file format\"."
---
```

**Improvements:**
- Reframed as action-oriented skill
- Explicit WHEN: triggers for common tasks
- No "DO NOT USE FOR:" (avoids keyword contamination with file-converter, etl-pipeline)

---

## Example 3: api-docs (Medium → Medium-High)

### Before (Medium Adherence)

**SKILL.md frontmatter:**
```yaml
---
name: api-docs
description: >-
  Generate API documentation from source code for REST and GraphQL endpoints.
  USE THIS SKILL when users want to document, describe, or generate reference
  material for their API. Trigger phrases include "document my API", "generate docs".
---
```

**Status:**
- Good trigger phrases
- Uses `>-` folded scalar (incompatible with skills.sh)

### After (Medium-High Adherence)

**SKILL.md frontmatter:**
```yaml
---
name: api-docs
description: "Generate API documentation from source code for REST and GraphQL endpoints. WHEN: \"document my API\", \"generate API docs\", \"OpenAPI spec\", \"Swagger docs\", \"API reference\", \"endpoint documentation\", \"describe my routes\"."
---
```

**Improvements:**
- Uses WHEN: with distinctive quoted trigger phrases
- Switched from `>-` folded scalar to inline double-quoted string
- Concise and cross-model optimized

---

## Example 4: Test Prompt Patterns

### Good Trigger Prompts

```javascript
// Specific and actionable
'Review this authentication module for security issues'
'Generate API docs for my Express routes'
'Convert this CSV file to a normalized JSON schema'

// Uses skill keywords
'Do a code review on my latest PR'
'Transform this dataset into Parquet format'

// Natural variations
'Can you check this code for me?'
'I need documentation for my API endpoints'
```

### Good Anti-Trigger Prompts

```javascript
// Unrelated topics (always include some)
'What is the weather today?',
'Help me write a poem about coding',
'Explain quantum computing',

// Adjacent but different domains
'Write unit tests for this function',           // → test-generator
'Refactor this code to be more readable',       // → code-refactor
'Deploy this app to production',                // → deployment skill
'Set up CI/CD for my project',                  // → ci-cd skill

// Related but different scope
'Explain how this algorithm works',             // → code-explanation
'Generate a changelog from git history',        // → release-notes
'Lint this file for style violations',          // → linter/formatter
```

---

## Example 5: Commit Message

**Good commit message:**
```
sensei: improve code-review frontmatter

- Added WHEN: trigger phrases: "review this code", "check my PR", etc.
- Updated trigger tests with 6 should-trigger and 7 should-not-trigger prompts
- Score improved: Low → Medium-High
- All tests passing
```

**Minimal commit message (also acceptable):**
```
sensei: improve code-review frontmatter
```

---

## Anti-Pattern Examples

### Don't Do This: Anti-Trigger Keyword Contamination

```yaml
description: "Review code for issues. USE FOR: \"code review\", \"check PR\". DO NOT USE FOR: writing tests (use test-generator), documentation (use api-docs), deployment (use deploy-skill)."
```

**Problem:** The "DO NOT USE FOR" clause introduces "tests", "documentation", "deployment" — on Claude Sonnet these keywords cause this skill to activate for testing, docs, and deploy tasks. Remove anti-triggers and use positive routing with distinctive `WHEN:` phrases instead.

### Don't Do This: Description Too Dense (>60 words)

```yaml
description: "This skill provides comprehensive code review capabilities including static analysis, security vulnerability scanning, performance profiling, accessibility checking, internationalization validation, dependency auditing, license compliance verification, and documentation completeness scoring for web applications, mobile apps, CLI tools, libraries, and microservices. USE FOR: review, check, audit, scan, validate, verify, analyze, inspect, examine..."
```

**Problem:** At 60+ words, attention is diluted across all skill descriptions. Cap at ≤60 words and front-load the unique signal.

### Don't Do This: Using >- Folded Scalars

```yaml
description: >-
  Review code for bugs and security issues.
  USE FOR: "code review", "check my PR", "find bugs".
```

**Problem:** The `>-` folded scalar syntax is incompatible with skills.sh and other registries. Use inline double-quoted strings instead.

### Don't Do This: Mismatched Tests

```yaml
# SKILL.md says:
WHEN: "review code", "check PR"
```

```javascript
// But trigger tests have:
const shouldTriggerPrompts = [
  'Write unit tests for this function',  // Wrong! This is test-generator
  'Format my code with prettier',        // Wrong! This is code-formatter
];
```

**Problem:** Test prompts don't match the actual trigger phrases.

---

## Example 6: Sensei Summary Output

After completing improvements, Sensei displays a summary:

```
╔══════════════════════════════════════════════════════════════════╗
║  SENSEI SUMMARY: code-review                                     ║
╠══════════════════════════════════════════════════════════════════╣
║  BEFORE                          AFTER                           ║
║  ──────                          ─────                           ║
║  Score: Low                      Score: Medium-High              ║
║  Tokens: 120                     Tokens: 350                     ║
║  Triggers: 0                     Triggers: 7                     ║
║                                                                  ║
║  TOKEN STATUS: Under budget (350 < 500)                          ║
║                                                                  ║
║  SUGGESTIONS NOT IMPLEMENTED:                                    ║
║  • (none - skill is under budget and clear)                      ║
║                                                                  ║
║  Choose an action:                                               ║
║    [C] Commit changes                                            ║
║    [I] Create GitHub issue with suggestions                      ║
║    [S] Skip (discard changes)                                    ║
╚══════════════════════════════════════════════════════════════════╝
```

### Summary with Token Suggestions

When token optimizations are available:

```
╔══════════════════════════════════════════════════════════════════╗
║  SENSEI SUMMARY: data-transform                                  ║
╠══════════════════════════════════════════════════════════════════╣
║  BEFORE                          AFTER                           ║
║  ──────                          ─────                           ║
║  Score: Medium                   Score: Medium-High              ║
║  Tokens: 623                     Tokens: 589                     ║
║  Triggers: 4                     Triggers: 8                     ║
║                                                                  ║
║  TOKEN STATUS: Above soft limit (589 > 500)                      ║
║                                                                  ║
║  SUGGESTIONS NOT IMPLEMENTED:                                    ║
║  • Remove bullet point decorators (-8 tokens)                    ║
║  • Shorten "In order to transform" → "To transform" (-12 tokens) ║
║  • Consolidate example list into paragraph (-18 tokens)          ║
║  Potential savings: ~38 tokens → 551 tokens                      ║
║                                                                  ║
║  Choose an action:                                               ║
║    [C] Commit changes                                            ║
║    [I] Create GitHub issue with suggestions                      ║
║    [S] Skip (discard changes)                                    ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## Skill Body Patterns

Templates for structuring the SKILL.md body content, adapted from Anthropic's [Complete Guide to Building Skills](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf).

### Pattern 1: Sequential Workflow
Use when users need multi-step processes in a specific order. Key techniques: explicit step ordering, dependencies between steps, validation at each stage.

### Pattern 2: Multi-MCP Coordination
Use when workflows span multiple services or MCP servers. Key techniques: clear phase separation, data passing between MCPs, validation before next phase.

### Pattern 3: Iterative Refinement
Use when output quality improves with iteration. Generate draft, run validation, address issues, re-validate, repeat until quality threshold met.

### Pattern 4: Context-Aware Tool Selection
Use when the same outcome requires different tools depending on context. Build a decision tree with clear criteria, fallback options, and transparency about choices.

### Pattern 5: Domain-Specific Intelligence
Use when the skill adds specialized knowledge beyond tool access. Apply domain rules before processing, document compliance decisions, maintain audit trail.
