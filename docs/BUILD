load("@aspect_bazel_lib//lib:docs.bzl", "stardoc_with_diff_test", "update_docs")
load("@stardoc//stardoc:stardoc.bzl", "stardoc")

stardoc(
    name = "docs",
    out = "docs.md",
    input = "docs_hub.bzl",
    symbol_names = [
        # Rules
        "glsl_shader",
        "hlsl_shader",
        "slang_shader",
        "download_sdk",

        # Toolchains
        "glsl_toolchain",
        "hlsl_toolchain",
        "slang_toolchain",
    ],
    deps = [
        "//glsl:bzl_lib",
        "//hlsl:bzl_lib",
        "//slang:bzl_lib",
        "//vulkan:bzl_lib",
    ],
)
