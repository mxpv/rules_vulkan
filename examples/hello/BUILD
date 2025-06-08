load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_vulkan//hlsl:shader.bzl", "hlsl_shader")

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

cc_binary(
    name = "hello",
    srcs = ["main.c"],
    data = [":hello_hlsl"],
    deps = ["@vulkan_sdk_1.4.313.0//:vulkan"],
)
