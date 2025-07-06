load("@aspect_bazel_lib//lib:write_source_files.bzl", "write_source_files")
load("@stardoc//stardoc:stardoc.bzl", "stardoc")

stardoc(
    name = "docs",
    out = "index_generated.md",
    input = "docs_hub.bzl",
    symbol_names = [
        # Rules
        "glsl_shader",
        "hlsl_shader",
        "slang_shader",
        "download_sdk",
        "shader_group",

        # Toolchains
        "vulkan_toolchain",

        # Providers
        "ShaderInfo",
    ],
    deps = [
        "//glsl:bzl_lib",
        "//hlsl:bzl_lib",
        "//slang:bzl_lib",
        "//vulkan:bzl_lib",
        "@bazel_skylib//lib:paths",
        "@bazel_skylib//rules:common_settings",
        "@rules_pkg//pkg:providers.bzl",
    ],
)

write_source_files(
    name = "update",
    files = {
        "index.md": ":docs",
    },
)
