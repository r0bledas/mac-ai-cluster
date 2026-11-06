# GGUF Model Storage Directory (`models/`)

Store all `.gguf` language model weights here on **Node A (MacBook Air 16GB)**.

### Model Location Mechanics:
* **Single Storage Location**: In `llama.cpp` RPC mode, you do **not** need to copy model files onto Node B (MacBook Pro 8GB). Node A reads the GGUF file from this directory, computes the tensor graph split, and streams Node B's share over the 40 Gbps Thunderbolt cable into its Metal VRAM at launch.

### Recommended Models for this 19.0 GB Usable VRAM Cluster:
| Filename Example | Architecture | Quantization | Size | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| `qwen2.5-14b-instruct-q4_k_m.gguf` | Qwen 2.5 14B | Q4_K_M | ~9.0 GB | Workhorse model with full 32k context |
| `qwen2.5-14b-instruct-q8_0.gguf` | Qwen 2.5 14B | Q8_0 | ~15.2 GB | Near-lossless high-precision inference |
| `gemma-2-27b-it-q3_k_m.gguf` | Gemma 2 27B | Q3_K_M | ~13.6 GB | High-capacity reasoning |
| `DeepSeek-R1-Distill-Qwen-14B-Q4_K_M.gguf` | DeepSeek R1 14B | Q4_K_M | ~9.1 GB | Offline chain-of-thought reasoning |
| `llama-3.1-8b-instruct-q8_0.gguf` | Llama 3.1 8B | Q8_0 | ~8.5 GB | Ultra-low latency generation (> 30 t/s) |

### Auto-Detection:
If you do not pass a path argument to `./scripts/start_coordinator_node_a.sh`, it automatically selects the first `.gguf` file found in this directory.
