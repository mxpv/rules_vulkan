load("@rules_go//go:def.bzl", "go_library")

go_library(
    name = "hlsl",
    srcs = ["lang.go"],
    importpath = "github.com/mxpv/rules_vulkan/language/hlsl",
    visibility = ["//visibility:public"],
    deps = [
        "@gazelle//config:go_default_library",
        "@gazelle//label:go_default_library",
        "@gazelle//language:go_default_library",
        "@gazelle//repo:go_default_library",
        "@gazelle//resolve:go_default_library",
        "@gazelle//rule:go_default_library",
    ],
)
