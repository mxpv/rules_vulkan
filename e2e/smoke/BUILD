load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_pkg//:pkg.bzl", "pkg_zip")
load("@rules_vulkan//glsl:rules.bzl", "glsl_shader")
load("@rules_vulkan//hlsl:rules.bzl", "hlsl_shader")
load("@rules_vulkan//slang:rules.bzl", "slang_shader")
load("@rules_vulkan//vulkan:rules.bzl", "shader_group")
load(":metadata.bzl", "gather_metadata")

hlsl_shader(
    name = "hello_hlsl",
    src = "shader.hlsl",
    out = "hello_hlsl.cso",  # (Optional) Bytecode output file.
    hdrs = ["//common:common_headers"],
    copts = ["-Ges"],  # Additional compiler options.
    defines = ["USE_VULKAN"],
    entry = "CSMain",
    hlsl = "2021",
    out_asm = "hello_hlsl.asm",  # Output assembly code
    out_hash = "hello_hlsl.hash",  # Output shader hash
    out_reflect = "hello_hlsl.reflect",  # Output reflection file
    target = "cs_6_0",
)

slang_shader(
    name = "hello_slang",
    src = "shader.hlsl",
    out = "hello_slang.spv",
    hdrs = ["//common:common_headers"],
    copts = ["-warnings-as-errors=all"],
    defines = ["USE_VULKAN"],
    entry = "CSMain",
    lang = "slang",
    out_depfile = "hello_slang.dep",
    out_reflect = "hello_slang.json",
    profile = "glsl_450",
    stage = "compute",
    target = "spirv",
)

glsl_shader(
    name = "hello_glsl",
    src = "shader.glsl",
    out = "hello_glsl.spv",
    hdrs = ["//common:common_headers"],
    stage = "comp",
    std = "450core",
    target_env = "vulkan1.4",
    target_spv = "spv1.6",
)

shader_group(
    name = "all_shaders",
    # Shader groups play nicely with `rules_pkg` and allow specifying location inside of an arhive.
    # See https://github.com/bazelbuild/rules_pkg/blob/main/docs/0.10.0/reference.md#pkg_files-prefix
    # Essentially, shader groups can be used inplace of `pkg_files` to bundle shader outputs.
    pkg_prefix = "shaders/",
    deps = [
        ":hello_glsl",
        ":hello_hlsl",
        ":hello_slang",
    ],
)

gather_metadata(
    name = "metadata",
    out = "metadata.json",
    deps = [":all_shaders"],
)

# This produces a new ZIP archive with metadata.json at root and ./shaders subdirectory with all shader outputs.
pkg_zip(
    name = "database",
    srcs = [
        ":all_shaders",
        ":metadata",
    ],
    out = "database.zip",
    compression_level = 0,  # Don't compress, just bundle files.
)

cc_binary(
    name = "app",
    srcs = ["main.c"],
    data = [
        ":database",
    ],
    deps = ["@vulkan_sdk_1.4.313//:vulkan"],
)
