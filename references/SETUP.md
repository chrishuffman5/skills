# Setup Guide

Complete setup walkthrough for the autoresearch environment.

## Prerequisites

### Hardware
- NVIDIA RTX desktop GPU (Turing, Ampere, Ada Lovelace, or Blackwell architecture)
- Minimum 8GB VRAM (Turing) or 10GB (Ampere and newer)
- Laptop GPUs are **not** officially supported (thermal throttling distorts timing)

### Software
- Windows 10/11 (primary target) or Linux
- Python 3.10 or newer
- Git
- NVIDIA drivers with CUDA support (installed via PyTorch wheels, no separate CUDA toolkit needed)

## Step-by-Step Setup

### 1. Install uv

`uv` is the package manager used by autoresearch. Install it:

**Windows (winget):**
```powershell
winget install astral-sh.uv
```

**Windows (pip):**
```bash
pip install uv
```

**Linux/macOS:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Verify: `uv --version`

### 2. Clone the Repository

```bash
git clone https://github.com/jsegov/autoresearch-win-rtx.git
cd autoresearch-win-rtx
```

### 3. Install Dependencies

```bash
uv sync
```

This installs all dependencies from `pyproject.toml`, including:
- PyTorch 2.9.1 with CUDA 12.8 wheels
- numpy, pandas, pyarrow (data handling)
- rustbpe, tiktoken (tokenizer)
- matplotlib (analysis)
- requests (dataset download)

The first run downloads ~2-3GB of PyTorch wheels. Subsequent runs use the cache.

### 4. Prepare Data

```bash
uv run prepare.py
```

This does three things:
1. **Downloads** the TinyStories GPT-4 clean dataset (~50K stories, single parquet file from HuggingFace)
2. **Trains** a BPE tokenizer (8192 vocab) using rustbpe
3. **Caches** everything to `%LOCALAPPDATA%\autoresearch\` (Windows) or `~/.cache/autoresearch/` (Linux)

Takes 1-3 minutes depending on download speed. Subsequent runs skip the download.

### 5. Smoke Test

```bash
uv run train.py --smoke-test
```

Runs a quick validation: 10 seconds of training (3 steps) to verify everything works. You should see:
- GPU detected and profiled
- Autotune running (benchmarks batch sizes)
- A few training steps with loss values
- A final `val_bpb:` line

If this passes, you're ready for real experiments.

### 6. Create Experiment Branch

Pick a short, memorable tag for this experiment session:

```bash
git checkout -b autoresearch/<tag>
```

Example: `git checkout -b autoresearch/mar24` or `git checkout -b autoresearch/arch-sweep`

### 7. Initialize Results Ledger

Create `results.tsv` with the header row:

```bash
echo -e "commit\tval_bpb\tmemory_gb\tstatus\tdescription" > results.tsv
```

Or on Windows PowerShell:
```powershell
"commit`tval_bpb`tmemory_gb`tstatus`tdescription" | Out-File -Encoding utf8 results.tsv
```

### 8. Run Baseline

Train the unmodified `train.py` to establish a baseline:

```bash
uv run train.py > run.log 2>&1
```

Parse the results from `run.log`:
```bash
grep "^val_bpb:\|^peak_vram_mb:" run.log
```

Record as the first entry in `results.tsv`:
```
<commit-hash>	<val_bpb>	<memory_gb>	baseline	unmodified train.py
```

You're now ready to enter the experiment loop.

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `AUTORESEARCH_CACHE_DIR` | `%LOCALAPPDATA%\autoresearch` | Override data/tokenizer cache location |
| `AUTORESEARCH_DATASET` | TinyStories | Override dataset selection |
| `AUTORESEARCH_DISABLE_AUTOTUNE` | unset | Set to `1` to skip GPU autotune |
| `AUTORESEARCH_AUTOTUNE_REFRESH` | unset | Set to `1` to force re-probe even if cached |
| `AUTORESEARCH_FORCE_CHECKPOINTING` | unset | Set to `1` or `0` to override activation checkpointing |

## GPU Autotune

On first run, autoresearch probes your GPU by benchmarking different (batch_size, checkpointing) combinations:

| VRAM Tier | Batch Candidates | Checkpointing |
|-----------|-----------------|---------------|
| 8-11 GB (Turing) | 8, 4, 2, 1 | Forced on |
| 10-15 GB | 16, 8, 4 | Forced on |
| 16 GB | 32, 16, 8, 4 | Optional |
| 24+ GB | 64, 32, 16, 8, 4 | Optional |

Results are cached per GPU fingerprint in a JSON file. To re-probe:
```bash
AUTORESEARCH_AUTOTUNE_REFRESH=1 uv run train.py
```

---

## Troubleshooting

### "CUDA not available"
- Verify GPU drivers: `nvidia-smi`
- Ensure PyTorch was installed with CUDA: `uv run python -c "import torch; print(torch.cuda.is_available())"`
- Reinstall with: `uv sync --reinstall`

### OOM During Training
- The autotune should prevent this, but if it happens:
  - Set `AUTORESEARCH_AUTOTUNE_REFRESH=1` and re-run
  - Or set `AUTORESEARCH_FORCE_CHECKPOINTING=1`
  - Or reduce batch size manually in `train.py`

### OOM During Evaluation
- Evaluation uses a separate eval_batch_cap (auto-configured)
- If eval OOMs, the evaluator automatically halves its batch size and retries
- If it still fails, reduce `EVAL_TOKENS` — but this changes the evaluation, so note it in results

### Slow First Run
- The first `uv sync` downloads ~2-3GB of PyTorch wheels
- The first `prepare.py` downloads the dataset and trains the tokenizer
- Autotune benchmarks on first run (~1-2 minutes)
- All of these are cached for subsequent runs

### Smoke Test Passes but Full Training Fails
- Usually a VRAM issue — smoke test uses tiny batches
- Run with `AUTORESEARCH_AUTOTUNE_REFRESH=1` to re-probe
- Check that no other GPU-consuming processes are running
