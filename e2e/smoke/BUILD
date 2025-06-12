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

glsl_shader(
    name = "hello_glsl",
    src = "shader.glsl",
    stage = "comp",
)

slang_shader(
    name = "hello_slang",
    src = "shader.slang",
    defines = ["USE_VULKAN"],
    entry = "computeMain",
    extra_args = ["-warnings-as-errors=all"],
    lang = "slang",
    profile = "glsl_450",
    target = "spirv",
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
