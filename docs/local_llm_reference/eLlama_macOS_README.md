# eLlama for macOS (Native SwiftUI)

A blazing-fast, lightweight desktop manager for local LLMs powered by `llama.cpp` and Apple **Metal** GPU acceleration, written natively in **Swift** and **SwiftUI**.

---

## Features

- **Pure Native Experience**: Designed specifically for macOS with SwiftUI, standard macOS menu bar, native dialogs, and dark mode support.
- **Metal Acceleration**: Uses Apple Metal (`ggml-metal`) out of the box on Apple Silicon (M1/M2/M3/M4) and Intel Macs, with unified memory layer offloading.
- **Instant GGUF Scanning**: Recursively indexes local model directories, parses quantization types (`Q4_K_M`, `Q8_0`, `BF16`, etc.), sizes, publishers, and filters vision projectors (`mmproj`).
- **Interactive Terminal Launching**: Spawns clean interactive sessions in macOS `Terminal.app` with custom window titles, or allows one-click copying of execution commands.
- **Auto-Update & Backend Manager**:
  - Automatically queries `ggml-org/llama.cpp` GitHub releases for native macOS Metal binaries (`llama-bXXXX-bin-macos-arm64.zip` / `macos-x64.zip`), downloads, and configures permissions with zero terminal friction.
  - Queries `r0bledas/eLlama` releases for macOS app updates.
- **Menu Bar / System Tray Mode**: Quick access to models and controls from the macOS menu bar.

---

## Requirements

- macOS 13.0 (Ventura) or newer (macOS 14 Sonoma & macOS 15 Sequoia supported).
- Xcode 15+ or Swift 5.9+ toolchain.

---

## Building from Source

### Quick Build with Swift Package Manager:

```bash
cd macos
swift build -c release
```

### Build `.app` Bundle & `.dmg` Installer:

```bash
chmod +x scripts/build_app.sh
./scripts/build_app.sh
```

The output bundle `eLlama.app`, portable `.zip`, and `.dmg` disk image will be generated in `macos/dist/`.

---

## Opening in Xcode

You can also open the Swift package directly in Xcode:

```bash
cd macos
open Package.swift
```

Select the `eLlama` executable scheme and hit **Run** (`Cmd + R`).
