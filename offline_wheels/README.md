# Offline Python Wheels Directory (`offline_wheels/`)

This directory holds pre-compiled `.whl` binary packages for running **Exo (`exo-explore/exo`)** and Apple Silicon **MLX** completely offline in air-gapped environments.

### How to Populate (While Connected to Internet):
```bash
./setup/bundle_offline_dependencies.sh download
```
This fetches the required Apple Silicon ARM64 wheels (`mlx`, `aiohttp`, `huggingface_hub`, `numpy`, `fastapi`, `pydantic`, etc.) directly into this folder.

### How to Install (When Air-Gapped / Offline):
```bash
./setup/bundle_offline_dependencies.sh install
```
This runs `pip install --no-index --find-links=offline_wheels/` to install all packages with zero internet connectivity and zero external network calls.
