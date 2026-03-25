---
name: autoresearch
description: "Run autonomous AI-driven research experiments that modify training code, train models, evaluate results, and iterate — all without human intervention. Based on Karpathy's autoresearch pattern. WHEN: \"autoresearch\", \"run experiments\", \"autonomous research\", \"overnight training\", \"experiment loop\", \"try training ideas\", \"optimize model\", \"LLM pretraining experiments\", \"start research loop\", \"run autoresearch\". Use this skill whenever the user wants to set up an autonomous experimentation loop on a machine learning training codebase, even if they don't say 'autoresearch' explicitly."
license: MIT
metadata:
  author: chrishuffman5
  version: "1.0.0"
---

# Autoresearch

> Let the agent run experiments while you sleep.

Autoresearch turns Claude into an autonomous ML researcher. You point it at a training codebase with a fixed evaluation harness, and it enters a loop: **modify code → commit → train → evaluate → keep or discard → repeat**. Overnight, it runs dozens of experiments, tracking every result in a ledger and git history.

Based on [karpathy/autoresearch](https://github.com/karpathy/autoresearch) and the Windows RTX fork at [jsegov/autoresearch-win-rtx](https://github.com/jsegov/autoresearch-win-rtx).

## Quick Start

The fastest path from zero to running experiments:

```
1. Clone the autoresearch repo into your project directory
2. Run: uv sync && uv run prepare.py
3. Run: uv run train.py --smoke-test
4. Tell Claude: "Start autoresearch with tag 'mar24'"
```

Or use Claude Code's `/loop` feature for periodic experimentation:
```
/loop 7m run the next autoresearch experiment — check results.tsv for history, modify train.py with a new idea, train, evaluate, keep or discard
```

## How It Works

Autoresearch follows a **keep/discard experiment loop** (a variant of the Ralph Wiggum pattern). The agent autonomously:

1. **Reads** the current training code and past results
2. **Plans** an experiment (architecture tweak, hyperparameter change, optimizer adjustment)
3. **Modifies** `train.py` and commits the change
4. **Runs** training for the time budget (default: 5 minutes)
5. **Evaluates** validation bits-per-byte (val_bpb) — a vocab-independent metric
6. **Keeps** the change if val_bpb improved (lower is better), **discards** otherwise
7. **Logs** everything to `results.tsv`
8. **Repeats** forever until stopped

Each experiment takes ~6-8 minutes (5 min training + eval + overhead). Overnight that's **~80-120 experiments**.

## Project Structure

```
autoresearch-win-rtx/
├── prepare.py      # READ-ONLY — dataset download, tokenizer, evaluation harness
├── train.py        # MODIFIABLE — model architecture, optimizer, hyperparameters
├── program.md      # Agent instructions (the original; this skill supersedes it)
├── pyproject.toml  # Dependencies (managed by uv)
├── analysis.ipynb  # Post-run visualization notebook
└── results.tsv     # Experiment ledger (created during setup phase)
```

**Critical rule:** Only modify `train.py`. Never touch `prepare.py` — it contains the evaluation metric and data loading. Changing it would invalidate all comparisons.

## Setup Phase

Before the experiment loop begins, complete these steps. See [SETUP.md](references/SETUP.md) for detailed instructions.

1. **Install uv** — The package manager (`pip install uv` or `winget install astral-sh.uv`)
2. **Install dependencies** — `uv sync`
3. **Prepare data** — `uv run prepare.py` (downloads TinyStories dataset, trains tokenizer)
4. **Smoke test** — `uv run train.py --smoke-test` (10-second validation run)
5. **Create experiment branch** — `git checkout -b autoresearch/<tag>`
6. **Initialize results ledger** — Create `results.tsv` with header
7. **Run baseline** — Train unmodified `train.py`, record as first entry

## The Experiment Loop

Once setup is complete, enter the autonomous loop. See [EXPERIMENT-LOOP.md](references/EXPERIMENT-LOOP.md) for the full protocol.

### Each Iteration

```
┌─────────────────────────────────────────────┐
│  1. CHECK STATE                             │
│     git status / git log --oneline -5       │
│     Read tail of results.tsv                │
└─────────────────┬───────────────────────────┘
                  ▼
┌─────────────────────────────────────────────┐
│  2. PLAN EXPERIMENT                         │
│     Review past results for patterns        │
│     Choose what to modify in train.py       │
│     Prefer bold architectural changes over  │
│     tiny hyperparameter tweaks              │
└─────────────────┬───────────────────────────┘
                  ▼
┌─────────────────────────────────────────────┐
│  3. MODIFY & COMMIT                         │
│     Edit train.py                           │
│     git add train.py                        │
│     git commit -m "exp: <description>"      │
└─────────────────┬───────────────────────────┘
                  ▼
┌─────────────────────────────────────────────┐
│  4. TRAIN                                   │
│     uv run train.py > run.log 2>&1          │
│     Wait for completion (~5 minutes)        │
└─────────────────┬───────────────────────────┘
                  ▼
┌─────────────────────────────────────────────┐
│  5. EVALUATE                                │
│     Parse run.log for val_bpb, peak_vram_mb │
│     If no output → crash → read traceback   │
└─────────────────┬───────────────────────────┘
                  ▼
┌─────────────────────────────────────────────┐
│  6. KEEP or DISCARD                         │
│     If val_bpb < best_so_far:               │
│       → KEEP (branch advances)              │
│     Else:                                   │
│       → DISCARD (git reset --hard HEAD~1)   │
│     Log to results.tsv either way           │
└─────────────────┬───────────────────────────┘
                  ▼
              REPEAT (go to step 1)
```

### Parsing Run Output

Training prints a structured summary block at the end. Parse these lines from `run.log`:

```
val_bpb:          0.997900
peak_vram_mb:     45060.2
```

**If those lines are missing**, the run crashed. Read the last 50 lines of `run.log` for the traceback, diagnose, and fix.

### Results Ledger

Every experiment is logged to `results.tsv` (tab-separated, 5 columns):

```
commit	val_bpb	memory_gb	status	description
a1b2c3d	1.042000	8.2	baseline	unmodified train.py
d4e5f6g	1.038500	8.3	keep	increase depth from 8 to 10 layers
h7i8j9k	1.045200	7.9	discard	replace RMSNorm with LayerNorm
```

Status is one of: `baseline`, `keep`, `discard`, `crash`, `oom`.

## Using with Claude Code's /loop Feature

For hands-off experimentation, use `/loop` to run experiments on a recurring interval:

```
/loop 7m read results.tsv, review recent experiments, modify train.py with a new idea, commit, run training with uv run train.py, evaluate val_bpb, keep or discard, log to results.tsv
```

The 7-minute interval gives enough time for a 5-minute training run plus overhead. Adjust based on your GPU and time budget.

Alternatively, for a more structured approach, invoke the full loop directly:

```
Start autoresearch with tag 'experiment-batch-1'. Read SETUP.md if first run. Then enter the experiment loop and don't stop.
```

## Experiment Strategy

See [IDEAS.md](references/IDEAS.md) for a catalog of experiment ideas.

**General principles:**
- **Be bold early.** The first experiments should try big architectural changes, not tiny hyperparameter tweaks. You learn more from 10x changes than 1.01x changes.
- **One variable at a time.** Each experiment should change one thing so you know what caused the result.
- **Read the history.** Check `results.tsv` before planning. Don't repeat failed ideas. Build on what worked.
- **Respect the VRAM.** If an experiment OOMs, it's a `crash` — try a smaller variant.
- **Don't chase noise.** If val_bpb changes by < 0.001, it's probably noise. Focus on bigger wins.

## Hardware Requirements

- **GPU:** NVIDIA RTX desktop GPU (Turing through Blackwell), minimum 8GB VRAM
- **Tested on:** RTX 3080 10GB, RTX 4090 24GB
- **OS:** Windows (primary target), Linux also supported
- **Software:** Python 3.10+, uv package manager, CUDA via PyTorch wheels

## Key Constants (from prepare.py — do not modify)

| Constant | Value | Meaning |
|----------|-------|---------|
| `MAX_SEQ_LEN` | 2048 | Context window length |
| `TIME_BUDGET` | 300 | Training time in seconds (5 minutes) |
| `EVAL_TOKENS` | 40 × 524288 | Tokens used for validation |
| `VOCAB_SIZE` | 8192 | BPE vocabulary size |

## Reference Documentation

- [SETUP.md](references/SETUP.md) — Full setup walkthrough with troubleshooting
- [EXPERIMENT-LOOP.md](references/EXPERIMENT-LOOP.md) — Detailed experiment loop protocol
- [IDEAS.md](references/IDEAS.md) — Catalog of experiment ideas to try
