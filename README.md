# M2 Mac Dual-Node Distributed AI Cluster (Offline Workload)

An end-to-end engineering blueprint and execution kit for clustering an **Apple Silicon M2 MacBook Air (16 GB)** and an **M2 MacBook Pro (8 GB)** into an optimized **19.0 GB Usable VRAM** offline inference engine using **Thunderbolt Bridge** (prioritized) or **Direct Ethernet** (fallback), supporting both **`llama.cpp` RPC** (for native GGUF models) and **`exo`** (for dynamic peer-to-peer MLX sharding) with **Dynamic On-Demand VRAM Switching**.

---

## 1. Executive Summary & Capabilities

| Metric | Node A (Coordinator) | Node B (Worker) | Combined Cluster |
| :--- | :--- | :--- | :--- |
| **Hardware** | M2 MacBook Air (Fanless) | M2 MacBook Pro (Active Fan) | Dual Apple Silicon M2 SoC |
| **Physical RAM** | 16 GB Unified LPDDR5 | 8 GB Unified LPDDR5 | **24 GB Physical Memory** |
| **macOS Default VRAM (~75%)** | ~11.5 GB | ~5.0 GB | ~16.5 GB |
| **Boosted VRAM (`iogpu`)** | **13.0 GB** (`13312 MB`) | **6.0 GB** (`6144 MB`) | **19.0 GB Dedicated VRAM** |
| **macOS Normal Headroom** | Restored to 100% when AI stops | Restored to 100% when AI stops | **Zero OS starvation** |
| **Interconnect Priority** | **Thunderbolt 3/4 (40 Gbps)** | **Thunderbolt 3/4 (40 Gbps)** | **< 0.15 ms latency / 25+ Gbps duplex** |
| **Interconnect Fallback** | USB-C Ethernet (1/2.5/10GbE) | USB-C Ethernet (1/2.5/10GbE) | 0.25 ms – 1.0 ms latency |
| **Max Standalone Model** | 8B Q8 or 14B Q4 (tight ctx) | 7B/8B Q4 (tiny ctx) | **14B Q8_0 or 27B-32B Q3/Q4 with full context** |

---

## 2. On-Demand VRAM Control Modes

Leaving `sysctl iogpu.wired_limit_mb` permanently elevated on an 8 GB or 16 GB Mac can restrict normal apps (browsers, IDEs) when you aren't doing AI. We provide **three clean modes** to elevate memory *only while AI is actively running*:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                        Three On-Demand VRAM Modes                      │
├──────────────────────────┬─────────────────────────────────────────────┤
│ 1. Built-in Auto-Trap    │ Runs automatically in start_coordinator.sh  │
│    (Recommended Default) │ and start_worker.sh. Traps Ctrl+C/Exit and  │
│                          │ immediately resets VRAM to 0 (default).     │
├──────────────────────────┼─────────────────────────────────────────────┤
│ 2. Cluster Sentinel      │ Background daemon (cluster_sentinel.sh).    │
│    (Set & Forget)        │ Monitors processes (llama-server, rpc, exo).│
│                          │ Automatically raises VRAM on start and drops│
│                          │ it back to 0 the instant they stop.         │
├──────────────────────────┼─────────────────────────────────────────────┤
│ 3. CLI Switcher & Wrapper│ ./scripts/vram_mode.sh on                   │
│    (Manual Control)      │ ./scripts/vram_mode.sh off                  │
│                          │ ./scripts/vram_mode.sh run <command...>     │
└──────────────────────────┴─────────────────────────────────────────────┘
```

### Mode 1: Automatic Lifecycle (Built-in)
You don't need to do anything special! When you run:
* `./scripts/start_coordinator_node_a.sh`: Automatically boosts Node A to 13.0 GB. When you stop it (`Ctrl+C`), it traps the signal, resets to `0`, and purges disk cache.
* `./scripts/start_worker_node_b.sh`: Automatically boosts Node B to 6.0 GB. When you stop it, it automatically resets to `0`.

### Mode 2: The Sentinel Watcher (Daemon)
To run a silent watcher in the background of either Mac:
```bash
sudo ./scripts/cluster_sentinel.sh
```
*Whenever you launch or kill any AI process (`llama-server`, `rpc-server`, or `exo`), the Sentinel detects it within 2 seconds, toggles `iogpu.wired_limit_mb` accordingly, and purges cache.*

### Mode 3: Manual Switcher & Command Wrapper
```bash
# Check current status
./scripts/vram_mode.sh status

# Manually toggle
sudo ./scripts/vram_mode.sh on
sudo ./scripts/vram_mode.sh off

# Run any command with ephemeral boost (auto-resets when command exits)
./scripts/vram_mode.sh run node-a exo
```

---

## 3. Directory Structure

```text
mac-ai-cluster/
├── README.md                          # Master architecture & operation manual
├── .gitignore                         # Git ignore rules for builds, models, and wheels
├── bin/                               # Prebuilt binary placeholder (drop prebuilt Mach-O binaries here)
│   └── README.md
├── models/                            # GGUF models directory (Node A NVMe storage)
│   └── README.md
├── offline_wheels/                    # Local storage for all air-gapped pip wheels
│   └── README.md
├── config/
│   └── cluster_env.sh                 # Master network IPs, ports, and memory variables
├── setup/
│   ├── fetch_prebuilt_binaries.sh     # Downloads official prebuilt macOS arm64 binaries
│   ├── optimize_macos_vram.sh         # Persistent VRAM configuration utility
│   ├── bundle_offline_dependencies.sh # Offline wheels bundler & model cache
│   ├── 01_thunderbolt_network.sh      # Thunderbolt Bridge + MTU 9000 setup (Preferred)
│   ├── 02_build_llamacpp.sh           # Metal + RPC compiler for Apple Silicon
│   ├── 03_ethernet_network.sh         # Direct Ethernet network automator (Fallback)
│   └── 04_setup_exo.sh                # Setup script for Exo (exo-explore/exo)
├── scripts/
│   ├── vram_mode.sh                   # On-demand VRAM CLI switcher & ephemeral wrapper
│   ├── cluster_sentinel.sh            # Background process-aware auto-VRAM watcher
│   ├── calculate_split.py             # Memory budget & --tensor-split calculator
│   ├── start_worker_node_b.sh         # Auto-boosting worker for Node B (Pro 8GB)
│   ├── start_coordinator_node_a.sh    # Auto-boosting coordinator for Node A (Air 16GB)
│   ├── cluster_benchmark.sh           # Latency and token/sec evaluator
│   └── test_offline_inference.py      # Pure Python offline streaming verification
├── services/
│   └── com.cluster.rpcworker.plist    # macOS LaunchAgent for headless worker boot
└── docs/
    ├── FOOLPROOF_OFFLINE_CLUSTER_GUIDE.md # Master troubleshooting, diagnostic trees, & FAQ
    └── local_llm_reference/           # Cloned local eLlama architecture & Metal documentation
        ├── eLlama_README.md
        ├── eLlama_PRODUCT.md
        └── eLlama_macOS_README.md
```

---

## 4. Full Offline Air-Gapped Readiness

Both engines are prepared with offline isolation:

### Option A: `llama.cpp` RPC (100% Offline by Design)
* **Zero External Dependencies**: Once compiled with `./setup/02_build_llamacpp.sh`, binaries link only to native macOS system libraries (`libSystem`, `Metal.framework`). No internet access is ever required.
* **Storage Efficiency**: The `.gguf` file is stored **only on Node A**. Node A slices the neural network and streams Node B's share over the Thunderbolt cable directly into its Metal VRAM at launch (~3–4 seconds).

### Option B: `exo` (Pre-Packaged Offline Wheel Cache)
Because Exo is written in Python, we provide a complete offline dependency bundler:
1. **Pre-Download Wheels (Run while online)**:
   ```bash
   ./setup/bundle_offline_dependencies.sh download
   ```
   *Downloads all `.whl` files (MLX, aiohttp, huggingface_hub, etc.) into `offline_wheels/`.*
2. **Pre-Cache Models (Run while online)**:
   ```bash
   ./setup/bundle_offline_dependencies.sh cache-model mlx-community/Qwen2.5-14B-Instruct-4bit
   ```
3. **Install Offline (Run air-gapped)**:
   ```bash
   ./setup/bundle_offline_dependencies.sh install
   ./setup/04_setup_exo.sh
   ```
   *Automatically sets `HF_HUB_OFFLINE=1` and `TRANSFORMERS_OFFLINE=1` so Exo never attempts to phone home.*

---

## 5. Network Setup

### Path A: Thunderbolt Bridge (Prioritized)
On **Node A (M2 Air 16GB)**:
```bash
sudo ./setup/01_thunderbolt_network.sh node-a
```
On **Node B (M2 Pro 8GB)**:
```bash
sudo ./setup/01_thunderbolt_network.sh node-b
```

### Path B: Ethernet (Alternative)
Plug your USB-C Ethernet adapters into both machines and connect a Cat6 cable:
On **Node A (M2 Air 16GB)**:
```bash
sudo ./setup/03_ethernet_network.sh node-a
```
On **Node B (M2 Pro 8GB)**:
```bash
sudo ./setup/03_ethernet_network.sh node-b
```

---

## 6. Execution Walkthrough

### Option 1: `llama.cpp` RPC (Native GGUF)
1. On both Macs: `./setup/02_build_llamacpp.sh`
2. On Node B (Pro 8GB): `./scripts/start_worker_node_b.sh` *(Auto-boosts to 6.0 GB VRAM)*
3. On Node A (Air 16GB): `./scripts/start_coordinator_node_a.sh path/to/model.gguf 8192` *(Auto-boosts to 13.0 GB VRAM)*
4. Verify inference: `python3 scripts/test_offline_inference.py`
5. *Press Ctrl+C when done: both Macs automatically drop back to standard macOS memory management!*

### Option 2: `exo` (MLX Dynamic Sharding)
1. On both Macs: `./setup/04_setup_exo.sh`
2. On Node B (Pro 8GB): `./scripts/vram_mode.sh run node-b exo`
3. On Node A (Air 16GB): `./scripts/vram_mode.sh run node-a exo`
4. Access web UI: `http://localhost:52415`
