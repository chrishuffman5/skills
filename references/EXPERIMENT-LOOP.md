# Experiment Loop Protocol

The complete protocol for the autonomous experiment loop. This is the core of autoresearch — the keep/discard cycle that runs indefinitely.

## Loop Overview

Each iteration follows this sequence:

```
CHECK STATE → PLAN → MODIFY → COMMIT → TRAIN → EVALUATE → KEEP/DISCARD → LOG → REPEAT
```

A single iteration takes ~6-8 minutes (5 min training + eval + overhead). The loop runs until manually stopped.

---

## Step 1: Check State

Before each experiment, establish context:

```bash
# Current branch and recent commits
git log --oneline -10

# Recent experiment results
tail -20 results.tsv

# Working directory clean?
git status
```

Parse `results.tsv` to understand:
- **Best val_bpb so far** — this is the bar to beat
- **What's been tried** — don't repeat failed ideas
- **Patterns** — what types of changes tend to improve results?

## Step 2: Plan Experiment

Choose a single, testable modification to `train.py`. See [IDEAS.md](IDEAS.md) for a catalog of ideas.

**Planning principles:**
- **One variable at a time.** Change one thing per experiment so you can attribute the result.
- **Bold early, fine-tune later.** Start with big architectural changes (2x depth, different attention pattern). Move to smaller tweaks once you've found a good region.
- **Build on successes.** If increasing depth helped, try increasing it more. If a new optimizer helped, try tuning its hyperparameters.
- **Learn from failures.** If increasing width hurt, try decreasing it. If a change crashed with OOM, try a smaller version.
- **Don't chase noise.** Differences < 0.001 in val_bpb are likely noise.

## Step 3: Modify train.py

Make the planned modification. Common edit locations:

| What to Change | Where in train.py |
|---------------|--------------------|
| Model dimensions | `num_layers`, `aspect_ratio`, `num_heads` constants |
| Attention pattern | `SSSL_PATTERN` or window size |
| Activation function | MLP block (ReLU² → GELU, SwiGLU, etc.) |
| Normalization | RMSNorm → LayerNorm, pre-norm vs post-norm |
| Optimizer settings | `MuonAdamW` class, learning rates, betas |
| LR schedule | Warmup/cooldown ratios, final LR fraction |
| Batch size | `TOTAL_BATCH_SIZE` or gradient accumulation |
| Residual scaling | `resid_lambda`, `x0_lambda` |

**Constraints:**
- Stay within VRAM limits (let autotune handle this, or be conservative)
- Don't change the evaluation interface (final print statements)
- Don't modify `prepare.py`
- Don't add new package dependencies

## Step 4: Commit

Every experiment gets its own commit, even if it will be discarded:

```bash
git add train.py
git commit -m "exp: <short description of what changed>"
```

Good commit messages:
```
exp: increase depth from 8 to 12 layers
exp: replace ReLU² with SwiGLU activation
exp: reduce Muon momentum from 0.95 to 0.90
exp: try wider model (aspect_ratio 48 → 32)
```

Store the commit hash:
```bash
COMMIT=$(git rev-parse --short HEAD)
```

## Step 5: Train

Run the training:

```bash
uv run train.py > run.log 2>&1
```

This takes ~5 minutes (the `TIME_BUDGET` constant in prepare.py). The training loop runs until the wall-clock budget is exhausted, then evaluates on the validation set.

**Do not interrupt training.** Let it run to completion so the evaluation is valid.

## Step 6: Evaluate

Parse the structured output from `run.log`:

```bash
grep "^val_bpb:\|^peak_vram_mb:" run.log
```

Expected output format:
```
val_bpb:          0.997900
peak_vram_mb:     45060.2
```

### If the lines are missing (crash)

The run failed. Diagnose:

```bash
tail -50 run.log
```

Common crash causes:
- **OOM** — Model too large for GPU. Log as `oom`, discard, try smaller variant.
- **NaN loss** — Training diverged. Log as `crash`, discard, try lower learning rate or different initialization.
- **Shape mismatch** — Code bug. Fix and re-run (don't count as a new experiment).
- **Import error** — Tried to use an unavailable package. Fix and re-run.

For code bugs (shape mismatch, import errors), fix the issue and re-commit with an amended message. These are implementation bugs, not failed experiments.

### Convert VRAM to GB

```python
memory_gb = round(peak_vram_mb / 1024, 1)
```

## Step 7: Keep or Discard

Compare the new `val_bpb` against the best result so far (the most recent `keep` or `baseline` entry in `results.tsv`):

### KEEP (val_bpb improved — lower is better)

The experiment succeeded. The branch advances:

```
Status: keep
# Branch stays at current commit
```

Update the best-known val_bpb for future comparisons.

### DISCARD (val_bpb same or worse)

The experiment didn't help. Reset to the previous good state:

```bash
git reset --hard HEAD~1
```

This removes the commit but the result is still logged in `results.tsv`.

### CRASH / OOM

The experiment failed to complete:

```bash
git reset --hard HEAD~1
```

Log with status `crash` or `oom`.

## Step 8: Log to results.tsv

Append one line to `results.tsv` for every experiment, regardless of outcome:

```
<commit>	<val_bpb>	<memory_gb>	<status>	<description>
```

| Field | Format | Example |
|-------|--------|---------|
| commit | 7-char git short hash | `a1b2c3d` |
| val_bpb | float, 6 decimal places | `0.997900` |
| memory_gb | float, 1 decimal place | `8.2` |
| status | `baseline`, `keep`, `discard`, `crash`, `oom` | `keep` |
| description | short text, no tabs | `increase depth from 8 to 12 layers` |

For crashes/OOM where val_bpb is unknown, use `NA`:
```
h7i8j9k	NA	NA	oom	try 16 layers with full batch
```

## Using /loop for Continuous Experimentation

Claude Code's `/loop` feature can automate the cycle. Set the interval slightly longer than your training time:

```
/loop 7m check results.tsv for experiment history, plan a new modification to train.py based on what has and hasn't worked, commit the change, run training with uv run train.py, evaluate the result, keep or discard, and log to results.tsv
```

**Tuning the interval:**
- 5-minute TIME_BUDGET + ~2 min overhead = ~7 min interval
- If the loop triggers while training is still running, it will wait for the next cycle
- Too short: overlapping runs. Too long: wasted idle time between experiments.

## Ralph Wiggum Loop Integration

The experiment loop naturally follows the Ralph Wiggum pattern — iterative improvement until a target is reached or diminishing returns set in:

1. **READ** — Load current state (results.tsv, train.py, git log)
2. **SCORE** — Current best val_bpb is the score to beat
3. **IMPROVE** — Modify train.py with an experiment
4. **VERIFY** — Run training and evaluate
5. **KEEP/DISCARD** — Only advance on improvement
6. **REPEAT** — Until stopped or no progress after N attempts

The key difference from traditional Ralph: there's no fixed "target score." Improvement is open-ended. The loop runs until:
- The human stops it
- The agent runs out of ideas
- val_bpb stops improving (diminishing returns)

---

## Post-Run Analysis

After a session, review results:

### Quick Summary
```bash
# Count experiments by status
awk -F'\t' 'NR>1 {print $4}' results.tsv | sort | uniq -c

# Best result
sort -t$'\t' -k2 -n results.tsv | head -5

# Show keep history (the progression of improvements)
grep 'keep\|baseline' results.tsv
```

### Visualization

Run the included analysis notebook:
```bash
uv run jupyter notebook analysis.ipynb
```

This generates progress charts showing val_bpb over time and which experiments contributed improvements.

### Git History

The git log on the experiment branch shows the progression of kept changes:
```bash
git log --oneline autoresearch/<tag>
```

Since discarded experiments are reset, only successful changes remain in the history — a clean record of what worked.
