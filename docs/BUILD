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
        "@bazel_skylib//lib:paths",
    ],
)

write_source_files(
    name = "update",
    files = {
        "index.md": ":docs",
    },
)
