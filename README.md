<p align="center">
  <img src="docs/logo.png" />
</p>

# rules_vulkan

`rules_vulkan` is a set of Bazel rules for integrating the [Vulkan SDK](https://vulkan.lunarg.com/) into your builds.
It streamlines downloading, installing, and using Vulkan SDKs across major platforms.

## Features
- Fully automatic SDK installation.
- Maintains a list of [currently available](./vulkan/private/versions.bzl) SDK versions on `LunarG`.
- Toolchains for `GLSL`, `HLSL`, and `Slang`.

