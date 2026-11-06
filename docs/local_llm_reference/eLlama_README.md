<p align="center">
  <img src="icon.png" alt="eLlama Logo" width="128" height="128" />
</p>

<h1 align="center">eLlama</h1>

<p align="center">
  <strong>Fast, native desktop manager & launcher for local GGUF models</strong><br>
  <em>Native Windows (.NET / Vulkan) & Native macOS (SwiftUI / Metal) powered directly by llama.cpp</em>
</p>

<p align="center">
  <a href="https://github.com/r0bledas/eLlama/releases/latest"><img src="https://img.shields.io/github/v/release/r0bledas/eLlama?style=flat-square&color=38bdf8" alt="Latest Release" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square" alt="License: MIT" /></a>
  <img src="https://img.shields.io/badge/Platform-Windows%20x64-0078D6?style=flat-square&logo=windows" alt="Windows" />
  <img src="https://img.shields.io/badge/Platform-macOS%20(Metal)-000000?style=flat-square&logo=apple" alt="macOS" />
</p>

Unlike traditional local runners that duplicate model weights into internal blob layers and eat gigabytes of disk space, eLlama executes `.gguf` files directly in place with **zero file copying**, **zero background daemons**, and **zero overhead**.

---

## Key Features

- **Zero-Copy In-Place Execution**: Streams `.gguf` models directly from your folder without duplicating disk space.
- **100% Portable Distribution**: Can run entirely standalone from any folder, external SSD, or USB flash drive without installation.
- **Cross-GPU Vulkan Acceleration**: Out-of-the-box hardware acceleration across Nvidia, AMD Radeon, and Intel GPUs without needing CUDA drivers or toolkits.
- **Built-in llama.cpp Updater**: Download or update to the latest official `llama.cpp` Vulkan release directly from the Settings interface with one click.
- **Model Catalog Exporter**: Export your entire local model catalog and metadata to CSV, JSON, Markdown, or Plain Text.
- **Fast Instant Search**: Real-time filtering across model names, publishers, quantization types, and filenames.
- **Vision Projector Auto-Filter**: Automatically recognizes and isolates vision projector files (`mmproj`) so your model list remains clean.
- **Interactive Terminal Chat**: Launch models into full interactive multi-turn conversations with a single double-click or by hitting Enter.
- **Numerical Sorting**: One-click sorting by file size (calculated numerically by bytes), model name, quant, or publisher.

---

## Portable Distribution Layout

eLlama supports a completely self-contained, portable folder structure:

```text
eLlama-Portable/
├── eLlama.exe               # Self-contained launcher (no .NET runtime install required)
├── settings.json            # Portable local settings (stored alongside eLlama.exe)
├── models/                  # Your .gguf model library
│   └── Llama-3-8B-Instruct.gguf
└── llama.cpp/               # llama.cpp binaries with Vulkan hardware acceleration
    ├── llama-cli.exe
    ├── ggml-vulkan.dll
    └── ... (supporting libraries)
```

When placed in this structure, eLlama automatically resolves all paths relatively (`models` and `llama.cpp\llama-cli.exe`), meaning you can move the folder anywhere or run it from a USB drive on any Windows PC.

---

## Advanced Inference Settings

eLlama includes full fine-grained control over inference, memory, and sampling:

### Hardware & Compute
- **CPU Threads (`-t`)**: Configurable thread allocation (1–64).
- **GPU Offload (`-ngl`)**: Offload model layers to GPU (Vulkan / CUDA / OpenCL) or set to `0` for pure CPU inference.
- **Context Size (`-c`)**: Built-in presets (`1024`, `2048`, `4096`, `8192`, `16384`, `32768`, `65536`) with **8K as default**, plus a dedicated **Custom Context** input for arbitrary token limits.
- **Batch & Micro-Batch Sizes (`-b` / `-ub`)**: Configurable prompt processing batch sizes.

### KV Cache & Memory Optimization
- **Quantized KV Cache (`-ctk` / `-ctv`)**: Select between `f16`, `q8_0`, and `q4_0` to drastically cut RAM usage during long context sessions.
- **Flash Attention (`-fa`)**: Toggle Flash Attention (`auto`, `on`, `off`) for faster inference and memory efficiency.
- **Memory Locking (`--mlock`)**: Lock weights into physical RAM to prevent OS disk paging.
- **Direct Memory Loading (`--no-mmap`)**: Disable memory mapping when needed.

### Sampling & Generation
- **Temperature (`--temp`)**: Precise control from `0.00` (deterministic/coding) to `2.00` (creative).
- **Top-P (`--top-p`)** & **Top-K (`--top-k`)**: Dual nucleus and cutoff sampling.
- **Min-P (`--min-p`)**: Minimum probability threshold sampling.
- **Repetition Penalty (`--repeat-penalty`)** & **Repeat Last N (`--repeat-last-n`)**: Prevent degenerative looping and repetition.
- **Max Generation Tokens (`-n`)**: Unlimited (`-1`) or custom token cutoff.

---

## Requirements

- **Operating System**: Windows 10 or Windows 11 (x64)
- **Runtime**: None required (bundled runtime in both Installer and Portable distributions); or [.NET 10.0](https://dotnet.microsoft.com/download) Windows Desktop Runtime for source builds.
- **Backend**: Pre-bundled [`llama.cpp`](https://github.com/ggml-org/llama.cpp/releases) (`llama-cli.exe`) with cross-GPU Vulkan acceleration.

---

## Installation & Downloads

Official releases are distributed in two clean options:
1. **Windows Installer ([`eLlama-Setup-v2.2.3.exe`](https://github.com/r0bledas/eLlama/releases/latest))**:
   - Modern, per-user setup (no administrator UAC prompts required).
   - Installs to `%LocalAppData%\Programs\eLlama`.
   - Creates Start Menu and Desktop shortcuts with custom application icon.
   - Includes full uninstaller registered in Windows Settings.
   - Seamlessly preserves user preferences and custom model directories across upgrades.
2. **Portable Edition ([`eLlama-Portable-v2.2.3-win-x64.zip`](https://github.com/r0bledas/eLlama/releases/latest))**:
   - Zero-installation zip package.
   - Extract to any folder, external SSD, or USB drive and launch immediately.

---

## Building from Source

```bash
git clone https://github.com/r0bledas/eLlama.git
cd eLlama
dotnet build -c Release
```

To build a self-contained portable release:
```bash
dotnet publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:EnableCompressionInSingleFile=true -o ./PortableRelease
```

To compile the Windows installer (requires Inno Setup 6):
```bash
iscc installer.iss
```

### macOS (Native SwiftUI / Swift)

Requires macOS 13.0+ and Xcode 15+ / Swift 5.9+:

```bash
cd macos
# Build release binary via Swift Package Manager
swift build -c release

# Or package complete eLlama.app bundle and .dmg
./scripts/build_app.sh
```

See [macos/README.md](macos/README.md) for full macOS details and Xcode configuration.

---

## Credits & Acknowledgements

eLlama is built on the shoulders of giants in the open-source and local AI community. Special thanks and attribution to:

- **[Georgi Gerganov](https://github.com/ggerganov) & the [llama.cpp community](https://github.com/ggml-org/llama.cpp)**: For developing the incredible `llama.cpp` and `ggml` engines that power high-performance local LLM inference across millions of devices.
- **[The Khronos Group Inc.](https://www.vulkan.org/)**: For the cross-platform Vulkan API enabling vendor-neutral GPU acceleration.
- **[The LLVM Project](https://llvm.org/)**: For the high-performance OpenMP multi-threading runtime.
- **[.NET Foundation & Microsoft](https://dotnet.microsoft.com/)**: For the .NET 10 desktop runtime and Windows Forms application platform.

---

## License & Legal Notices

- **eLlama**: Licensed under the [MIT License](LICENSE). Copyright (c) 2026 Raudel.
- **Third-Party Components & Dependencies**: All bundled or interfaced third-party tools (including `llama.cpp`, `ggml`, `libomp.dll`, and Vulkan) are distributed under their respective open-source licenses. For complete copyright notices and license texts, see [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).



