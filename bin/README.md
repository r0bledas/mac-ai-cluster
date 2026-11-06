# Precompiled Binary Placeholder (`bin/`)

Place pre-compiled Apple Silicon (ARM64) Mach-O binaries here if you are operating in an air-gapped environment and copying pre-built tools over a USB flash drive or SSD instead of compiling via CMake.

### Expected Binaries in This Folder:
* `llama-server`: The core OpenAI-compatible HTTP inference daemon.
* `rpc-server`: The remote Metal GPU worker daemon (runs on Node B).
* `llama-cli`: Interactive terminal chat binary.
* `llama-bench`: Microbenchmark performance tester.
* Supporting dynamic libraries (`libggml.dylib`, `libllama.dylib`, etc. if built with shared libs).

### Binary Resolution:
The cluster launch scripts (`start_coordinator_node_a.sh`, `start_worker_node_b.sh`, and `cluster_benchmark.sh`) automatically search this `bin/` directory first before falling back to `llama.cpp/build/bin/`.

### Permissions on macOS:
After copying binaries into this directory, ensure executable permissions and clear quarantine flags:
```bash
chmod +x bin/*
xattr -dr com.apple.quarantine bin/* 2>/dev/null || true
```
