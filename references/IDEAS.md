# Experiment Ideas

A catalog of modifications to try in `train.py`, organized by category. Start with bold changes and refine based on results.

## Architecture

### Depth and Width
- **Increase depth** — Try 10, 12, 16 layers (default: 8). Deeper models capture more complex patterns but train slower per step.
- **Change aspect ratio** — Lower aspect_ratio means wider model. Try 48, 32, or 24 (default: 64). Width vs depth is a fundamental tradeoff.
- **Increase head count** — Try 8 or 16 heads (default: 4). More heads can capture different attention patterns but increase parameter count.
- **Asymmetric layers** — Not all layers need the same width. Try wider early layers and narrower later ones (or vice versa).

### Attention
- **Modify SSSL pattern** — The default sliding-window pattern is 3 short + 1 long. Try 2+1, 4+1, 1+1, or all-long (full attention).
- **Change window sizes** — Modify the short-window length. Smaller windows are faster but miss long-range dependencies.
- **Remove sliding window entirely** — Use full attention for all layers. Slower but more expressive.
- **Add local + global attention** — Alternate between local-only and full-attention layers.

### Normalization
- **RMSNorm → LayerNorm** — Standard LayerNorm has a learnable bias. May help or hurt.
- **Pre-norm vs post-norm** — Move normalization before vs after attention/MLP.
- **QK-norm** — Add normalization to query and key projections (helps stability at scale).
- **Remove normalization** — Some recent work shows normalization-free architectures can work. Risky but worth trying.

### Activation Functions
- **ReLU² → GELU** — GELU is the standard in modern transformers.
- **ReLU² → SwiGLU** — SwiGLU is state-of-the-art but adds parameters.
- **ReLU² → plain ReLU** — Simpler, faster, sometimes competitive.
- **Try Mish or ELU** — Less common but occasionally useful.

### Embeddings and Output
- **Value embeddings** — The default uses gated value embeddings on alternating layers. Try enabling on all layers, or disabling entirely.
- **Residual scaling** — Modify `resid_lambda` and `x0_lambda`. Try removing the residual stream scaling entirely.
- **Logit soft-capping** — Default is 15. Try 30, 50, or disable it.
- **Tied embeddings** — Try tying input and output embeddings (share weights).

## Optimizer

### Learning Rates
- **Scale matrix_lr** — Default 0.04. Try 0.02, 0.08, 0.1.
- **Scale embedding_lr** — Default 0.6. Embeddings often benefit from different LR than the rest.
- **Scale unembedding_lr** — Default 0.004. Try matching it to embedding_lr.
- **Uniform LR** — Try the same LR for all parameter groups.

### Momentum and Betas
- **Muon momentum range** — Default ramps 0.85→0.95. Try 0.90→0.99 or fixed 0.95.
- **AdamW betas** — Default (0.9, 0.95). Try (0.9, 0.999) or (0.95, 0.99).

### LR Schedule
- **Warmup ratio** — Default 0.0 (no warmup). Try 0.05 or 0.1.
- **Cooldown ratio** — Default 0.5. Try 0.3 or 0.7.
- **Final LR fraction** — Default 0.0 (cosine to zero). Try 0.1 (don't decay fully).
- **Cosine → linear decay** — Replace cosine cooldown with linear.

### Weight Decay
- **Increase/decrease** — Try 2x or 0.5x the current weight decay.
- **Selective decay** — Only apply weight decay to certain parameter groups.

### Alternative Optimizers
- **Replace Muon entirely** — Use pure AdamW or SGD with momentum for all parameters.
- **Try Lion** — Simpler than Adam, sometimes competitive.
- **Try LAMB/LARS** — Large-batch optimizers, may help with high gradient accumulation.

## Training Dynamics

### Batch Size
- **Increase TOTAL_BATCH_SIZE** — Default 524288 tokens. Try 1M or 2M. Larger batches can improve training stability.
- **Decrease TOTAL_BATCH_SIZE** — Try 256K. Smaller batches mean more gradient steps in the time budget.
- **Gradient accumulation** — If VRAM allows larger device_batch_size, reduce accumulation steps for faster training.

### Initialization
- **Scale initial weights** — Try smaller or larger initialization.
- **Orthogonal initialization** — For attention projections.
- **Zero-init residual** — Initialize the last linear in each block to near-zero.

### Regularization
- **Dropout** — Add dropout (0.1, 0.05) to attention or MLP. May hurt small models but worth testing.
- **Stochastic depth** — Randomly skip layers during training. Can regularize deep models.

### Data Efficiency
- **Sequence packing** — The dataloader already does best-fit packing. Try changing the packing strategy.
- **Curriculum** — Sort sequences by length during early training, randomize later.

## Meta-Strategies

### Combining Improvements
After finding individual improvements, combine the top 2-3:
```
Experiment N: combine {depth 12} + {SwiGLU} + {higher Muon momentum}
```

### Ablation Studies
If a combined change helps, ablate to confirm each component matters:
```
Experiment N+1: remove {SwiGLU} from the winning config
Experiment N+2: remove {depth 12} from the winning config
```

### Scaling Laws
Once you have a good architecture, try scaling:
```
Small: 25M params → Medium: 50M → Large: 100M
```
(Stay within VRAM and time budget)

---

## What Not to Try

- **Changes to prepare.py** — This breaks the evaluation metric and invalidates all comparisons.
- **New package dependencies** — The environment is fixed.
- **Multi-GPU training** — The codebase is single-GPU only.
- **Changes to TIME_BUDGET** — Changing training time makes results incomparable.
- **Entirely different model families** — Stay within the GPT/transformer architecture. Replacing with an LSTM or SSM is a different project.
