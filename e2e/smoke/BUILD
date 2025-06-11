load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_vulkan//glsl:shader.bzl", "glsl_shader")
load("@rules_vulkan//hlsl:shader.bzl", "hlsl_shader")
load("@rules_vulkan//slang:shader.bzl", "slang_shader")

hlsl_shader(
    name = "hello_hlsl",
    src = "shader.hlsl",
    defines = ["USE_VULKAN"],
    entry = "CSMain",
    extra_args = ["-Ges"],
    hlsl_version = "2021",
    spirv = True,
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
    ] + select({
        # TODO: Enable HLSL and Slang on Windows.
        "@platforms//os:windows": [],
        "//conditions:default": [
            ":hello_hlsl",
            ":hello_slang",
        ],
    }),
    deps = ["@vulkan_sdk_1.4.313.0//:vulkan"],
)
