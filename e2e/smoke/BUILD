load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_vulkan//glsl:shader.bzl", "glsl_shader")
load("@rules_vulkan//hlsl:shader.bzl", "hlsl_shader")
load("@rules_vulkan//slang:shader.bzl", "slang_shader")

hlsl_shader(
    name = "hello_hlsl",
    src = "shader.hlsl",
    out = "hello_hlsl.cso",  # (Optional) Bytecode output file.
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
    stage = "comp",
)

cc_binary(
    name = "app",
    srcs = ["main.c"],
    data = [
        ":hello_glsl",
        ":hello_hlsl",
        ":hello_slang",
    ],
    deps = ["@vulkan_sdk_1.4.313//:vulkan"],
)
