# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`rules_vulkan` is a set of Bazel rules for integrating the Vulkan SDK into builds. It automates downloading,
installing, and using Vulkan SDKs across Windows, Linux, and macOS platforms. The rules support compiling GLSL,
HLSL, and Slang shaders, plus spirv-cross transpilation.

## Common Commands

### Build and Test
- `bazelisk test //vulkan/tests/...` - Run unit tests
- `bazelisk run :app --verbose_failures` - Run the e2e smoke test (from e2e/smoke directory)
- `bazelisk build //...` - Build all targets

### Linting and Formatting
- `bazelisk run :lint` - Check Bazel file formatting (lint mode)
- `bazelisk run :fmt` - Format Bazel files with buildifier

### Documentation
- `bazelisk run //docs:update_test` - Verify documentation is up to date

### SDK Version Updates
- `python tools/update_versions.py` - Fetch latest Vulkan SDK versions and update versions.bzl
- After running the script, format with `bazelisk run :fmt`
- If there are changes in versions.bzl after formatting, create a PR with the updates
- If no changes, report "no new versions available" and specify the latest currently available version

## Architecture

### Core Components

**Vulkan SDK Management**: The `download_sdk` rule and `vulkan_sdk` module extension handle automatic SDK download
and installation. Available SDK versions are maintained in `vulkan/private/versions.bzl` (updated via
`tools/update_versions.py`). The `versions.bzl` file contains a list of known Vulkan SDK versions available on the
LunarG website. Use `tools/update_versions.py` to fetch available versions and rebuild `versions.bzl`. Note that
`versions.bzl` must be reformatted after fetching.

**Shader Compilation Rules**: 
- `glsl_shader` - Compiles GLSL shaders using glslc
- `hlsl_shader` - Compiles HLSL shaders using DirectXShaderCompiler (dxc)
- `slang_shader` - Compiles Slang shaders using slangc
- `spirv_cross` - Transpiles SPIR-V to other shader languages

**Toolchain System**: Uses Bazel toolchains to provide compiler binaries (dxc, glslc, slangc, spirv-cross) from the
downloaded SDK.

**Providers and Info**: `ShaderInfo` and `ShaderGroupInfo` providers carry metadata about compiled shaders for
building shader databases.

### File Structure

- `vulkan/defs.bzl` - Main public API exports
- `vulkan/private/` - Implementation details for each shader compiler
- `vulkan/extensions.bzl` - Module extension for SDK management
- `vulkan/toolchains.bzl` - Toolchain definitions
- `e2e/smoke/` - Integration test showcasing all features

## Guidelines

### Code Quality
- Write clean and idiomatic Starlark code following Bazel best practices
- All public APIs must include comprehensive documentation
- Proofread documentation for clarity and accuracy

### Commit Messages
- Use descriptive commit messages that explain the change and its purpose
- Do not include AI tool references, co-authorship attributions, or generation credits in commit messages

### Pre-Push Checklist
Before pushing code to the repository, ensure the following steps are completed:
1. Update documentation: `bazelisk run //docs:update`
2. Run buildifier linter and formatter: `bazelisk run :lint` and `bazelisk run :fmt`
3. Execute e2e tests to verify functionality

## Documentation

Generated API documentation is available in `docs/index.md` with detailed descriptions of all rules, attributes,
and providers.

## Testing

The project has both unit tests (`vulkan/tests/`) and integration tests (`e2e/smoke/`). The CI runs tests across
Windows, Linux, and macOS with multiple Bazel versions.