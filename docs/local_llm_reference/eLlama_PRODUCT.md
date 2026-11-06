# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

## Users

Primary users are individuals running large language models locally on their personal hardware, spanning two core profiles:
- Everyday AI enthusiasts who want a clean, one-click launcher to run downloaded GGUF models locally without dealing with terminal commands or Python environments.
- Developers and power users who need fine-grained control over hardware offloading (Metal GPU layers, CPU threads), context limits, sampling hyperparameters, and local OpenAI-compatible HTTP server endpoints (`llama-server`) for API integration.

## Product Purpose

eLlama exists to provide a native, lightweight, and robust desktop interface for `llama.cpp`. It bridges the gap between raw command-line inference binaries and end users, delivering instant model discovery, terminal chat execution, and background server hosting with zero cloud dependency.

Success means a user can point eLlama to their models folder, select any GGUF model, tune hardware and sampling parameters through an authentic native settings interface, and launch an interactive chat or API server in seconds.

## Positioning

Unlike bloated Electron-based model managers or monolithic AI containers, eLlama is a compact, high-performance native desktop application (SwiftUI on macOS, .NET on Windows) that directly orchestrates standalone `llama.cpp` binaries (`llama-cli` and `llama-server`). It adds zero runtime overhead, respects native operating system interface guidelines, and leaves model weights and execution completely under user control.

## Operating Context

- Local workstations (Apple Silicon Macs with unified memory; Windows PCs with CPU/GPU).
- Offline, private, or air-gapped development environments.
- Terminal-driven chat sessions launched directly into the user's default terminal emulator.
- Local API server workflows powering external applications, scripts, or IDE extensions via OpenAI-compatible endpoints (`http://127.0.0.1:8080/v1`).
- Multi-gigabyte GGUF model management across internal drives and external storage.

## Capabilities and Constraints

- **Model Discovery**: Scans local directories for `.gguf` files, parsing architecture, quantization type, file size, and vision projector (`mmproj`) tags.
- **Interactive Execution**: Constructs optimized CLI argument strings and launches interactive chat via `llama-cli` in native macOS Terminal.
- **Server Serving**: Configures and launches background `llama-server` instances with customizable host bindings (localhost or LAN) and port allocation.
- **Hardware Acceleration**: Granular configuration for Metal GPU layer offloading, CPU thread allocation, logical/physical batch sizing, and context sizes up to 128K tokens with preset shortcuts.
- **Inference & Sampling**: Full parameter control over temperature, top-P, top-K, min-P, repetition penalties, repeat window, max token limits, and KV cache quantization (f16, q8_0, q4_0).
- **Binary Management**: Automatic update checking and one-click downloading for both the eLlama application and precompiled Metal-optimized `llama.cpp` releases.
- **Strict Brand Constraint**: Zero emojis in the UI, code, labels, status text, or scripts.
- **Strict Design Constraint**: Strict adherence to native Apple Human Interface Guidelines and macOS System Settings patterns on macOS; clean Windows Forms patterns on Windows.

## Brand Commitments

- **Name**: eLlama
- **Tone**: Technical, utilitarian, precise, uncluttered, focused.
- **Aesthetic**: Strictly native OS styling, system typography, system colors, zero decorative embellishments or emojis.
- **Assets**: Application icon set (`AppIcon.icns`, `icon.png`).

## Evidence on Hand

- Native macOS SwiftUI source tree under `macos/Sources/eLlama/`.
- Native Windows C# / WinForms source tree under `windows/`.
- Verified release build and packaging pipeline (`macos/scripts/build_app.sh`) producing `.app`, ZIP, and DMG artifacts.
- Functional `UpdateManager` with GitHub API releases integration for `llama.cpp` and `eLlama`.

## Product Principles

1. **Native over Synthetic**: Use authentic platform controls and paradigms (macOS grouped forms, standard system pickers, native menus) rather than custom web-like abstractions.
2. **Fast Defaults, Deep Controls**: Standard operations (Run Chat, Serve Model) work instantly with intelligent defaults, while deep hardware and sampling configuration remains one click away.
3. **Transparent Orchestration**: Never hide what is being executed. Paths, resolved flags, and endpoints are visible and verifiable.
4. **Zero Overhead & Total Privacy**: Completely local, telemetry-free, offline-first. The app serves the inference engine, not itself.
5. **Aesthetic Discipline**: Restrained, clear visual hierarchy without distracting ornamentation or emojis.

## Accessibility & Inclusion

- Native dynamic type and contrast support leveraging macOS and Windows system color semantics.
- Full keyboard accessibility and standard shortcut navigation for all primary actions.
