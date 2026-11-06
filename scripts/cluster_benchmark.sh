#!/usr/bin/env bash
# ==============================================================================
# CLUSTER BENCHMARK SCRIPT
# Measures Prompt Processing (t/s) and Text Generation (t/s) across nodes
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config/cluster_env.sh"

BENCH_BIN="$LLAMA_DIR/build/bin/llama-bench"

echo "=========================================================="
echo " M2 Dual-Mac Distributed Inference Benchmark"
echo "=========================================================="

if [[ ! -f "$BENCH_BIN" ]]; then
    echo "[!] Error: llama-bench binary not found at $BENCH_BIN."
    exit 1
fi

MODEL_PATH="${1:-}"
if [[ -z "$MODEL_PATH" ]]; then
    FIRST_GGUF=$(find "$MODELS_DIR" -name "*.gguf" 2>/dev/null | head -n 1 || true)
    if [[ -n "$FIRST_GGUF" ]]; then
        MODEL_PATH="$FIRST_GGUF"
    else
        echo "Usage: $0 <path_to_model.gguf>"
        exit 1
    fi
fi

echo "[*] Benchmarking Model: $MODEL_PATH"
echo "[*] Testing: Prompt Processing (512 tokens) & Generation (128 tokens)"
echo "----------------------------------------------------------"
echo "RUN 1: Distributed Cluster (Node A Local Metal + Node B RPC Metal)"
echo "----------------------------------------------------------"

"$BENCH_BIN" \
    -m "$MODEL_PATH" \
    --rpc "$NODE_B_IP:$RPC_PORT" \
    --tensor-split "$DEFAULT_TENSOR_SPLIT" \
    -ngl 99 \
    -p 512 -n 128 \
    -r 3

echo "=========================================================="
echo "Benchmark completed."
echo "=========================================================="
