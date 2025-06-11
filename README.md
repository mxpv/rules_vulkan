<p align="center">
  <img src="docs/logo.png" />
</p>

# rules_vulkan

[![CI](https://github.com/mxpv/rules_vulkan/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/mxpv/rules_vulkan/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/mxpv/rules_vulkan)](./LICENSE)


`rules_vulkan` is a set of [Bazel](https://bazel.build) rules for integrating the [Vulkan SDK](https://vulkan.lunarg.com/)
into your builds. It streamlines downloading, installing, and using Vulkan SDKs across major platforms.

- [Documentation](./docs/index.md)
- [Download SDKs](https://vulkan.lunarg.com)

## Features
- Fully automated SDK installation.
- Maintains a list of [currently available](./vulkan/private/versions.bzl) SDK versions on `LunarG`.
- Toolchains for `GLSL`, `HLSL`, and `Slang`.
- Unit and integration tests on CI.
- Available on [BCR](https://registry.bazel.build/modules/rules_vulkan).
- A nice-looking AI-generated logo!


## :beginner: Getting started

To get started, you’ll need to fetch the Vulkan SDK and register the toolchains.
Add the following to your `MODULE.bazel` file:

```bazel
bazel_dep(name = "rules_vulkan", version = "0.1")

vulkan_sdk = use_extension("@rules_vulkan//vulkan:extensions.bzl", "vulkan_sdk")

vulkan_sdk.download(version = "1.4.313")
use_repo(vulkan_sdk, "vulkan_sdk_1.4.313")

register_toolchains("@vulkan_sdk_1.4.313//:all")
```

Then use it in your `BUILD` files:

```bazel
load("@rules_vulkan//hlsl:shader.bzl", "hlsl_shader")

hlsl_shader(
    name = "hello_hlsl",
    src = "shader.hlsl",
    entry = "CSMain",
    target = "cs_6_0",
    spirv = True,
)

cc_binary(
    name = "app",
    srcs = ["main.c"],
    data = [":hello_hlsl"],
    deps = ["@vulkan_sdk_1.4.313//:vulkan"],
)

```

Refer to `e2e` project [here](./e2e/smoke/) for a more complete setup.

## :cockroach: Known issues
- https://github.com/mxpv/rules_vulkan/issues/1 End-to-end tests on `Windows` are currently disabled in CI due to the missing `vulkan-1.dll`,
  which is not included in the SDK package. This DLL is distributed separately as part of the Vulkan "runtime"
  package and requires additional handling.
- https://github.com/mxpv/rules_vulkan/issues/2 On Windows, `dxc.exe` fails due to symlink issues—native_binary does not copy `dxcompiler.dll` to the output directory.

## License

The project itself is licensed under [`Apache 2.0`](./LICENSE) license.

> [!NOTE]
> This project downloads packages from LunarG, please ensure you comply with their license terms.

