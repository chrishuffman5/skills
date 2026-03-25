# Token Integration

Sensei integrates token awareness into the improvement loop to ensure skills stay within budget while improving frontmatter compliance.

## Token Budgets

| File Type | Soft Limit | Hard Limit |
|-----------|------------|------------|
| SKILL.md | 500 tokens | 5000 tokens |
| references/*.md | 1000 tokens | - |
| Total skill | 2000 tokens | - |

## Estimating Tokens

Since exact tokenization depends on the model, use these approaches:

**Quick word-count estimate:**
```bash
wc -w {skill-name}/SKILL.md
```
Rough conversion: 1 token ≈ 0.75 words (so 500 tokens ≈ 375 words).

**More accurate (if Python available):**
```bash
python3 -c "
import pathlib, sys
text = pathlib.Path(sys.argv[1]).read_text()
# Rough: split on whitespace and punctuation boundaries
tokens = len(text.split()) * 1.33  # words → tokens multiplier
print(f'~{int(tokens)} tokens ({len(text.split())} words)')
" {skill-name}/SKILL.md
```

**With tiktoken (most accurate):**
```bash
pip install tiktoken
python3 -c "
import tiktoken, pathlib, sys
enc = tiktoken.get_encoding('cl100k_base')
text = pathlib.Path(sys.argv[1]).read_text()
tokens = len(enc.encode(text))
print(f'{tokens} tokens')
" {skill-name}/SKILL.md
```

## Integration Points

### 1. READ Phase (Capture Baseline)

At loop start, capture initial token/word count and store as `beforeTokens`.

### 2. CHECK TOKENS Phase (After Improvements)

After frontmatter improvements pass tests, re-count and compute:
- `afterTokens` — current count
- `tokenDelta = afterTokens - beforeTokens`
- `suggestions` — optimization opportunities

### 3. SUMMARY Phase (Report)

Include in summary:
- Token count before/after
- Delta (+/- tokens)
- Suggestions not implemented (for user review)

## Optimization Patterns

### Quick Reference: Common Optimizations

| Pattern | Savings | Example |
|---------|---------|---------|
| Remove emojis | 1-3 tokens each | Remove decorative emoji |
| Shorten headings | 2-5 tokens | `## Step 1: Configuration` → `## Configuration` |
| Remove filler words | 1-2 tokens each | "In order to" → "To" |
| Consolidate lists | 5-10 tokens | Multiple bullets → single sentence |
| Use abbreviations | 1-2 tokens | "Application Programming Interface" → "API" |

## When to Apply Token Suggestions

Sensei captures token optimization suggestions but does **not** auto-apply them. The user decides:

**Apply immediately if:**
- Skill exceeds soft limit (500 tokens)
- Suggestions don't reduce clarity
- Changes are straightforward

**Create issue if:**
- Suggestions require careful review
- Multiple skills need same optimization
- Changes might affect functionality

**Skip if:**
- Skill is well under budget
- Suggestions trade clarity for brevity
- Time constraints

## Example Summary with Tokens

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
║  • (none - skill is under budget)                                ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```
