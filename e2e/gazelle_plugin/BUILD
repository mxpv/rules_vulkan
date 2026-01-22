load("@gazelle//:def.bzl", "gazelle", "gazelle_binary")
load("@rules_vulkan//vulkan:defs.bzl", "hlsl_shader")

gazelle_binary(
    name = "gazelle_bin",
    languages = ["@rules_vulkan//language/hlsl"],
)

gazelle(
    name = "gazelle",
    gazelle = ":gazelle_bin",
)

hlsl_shader(
    name = "test",
    src = "test.hlsl",
    entry = "main",
    target = "cs_6_0",
)
