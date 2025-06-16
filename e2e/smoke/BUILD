load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_vulkan//glsl:shader.bzl", "glsl_shader")
load("@rules_vulkan//hlsl:shader.bzl", "hlsl_shader")
load("@rules_vulkan//slang:shader.bzl", "slang_shader")
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
    deps = [
        ":hello_glsl",
        ":hello_hlsl",
        ":hello_slang",
    ],
)

gather_metadata(
    name = "all_shaders_metadata",
    out = "metadata.json",
    deps = [":all_shaders"],
)

cc_binary(
    name = "app",
    srcs = ["main.c"],
    data = [
        ":all_shaders",
        ":all_shaders_metadata",
    ],
    deps = ["@vulkan_sdk_1.4.313//:vulkan"],
)
