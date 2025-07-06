load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

bzl_library(
    name = "bzl_lib",
    srcs = [
        "defs.bzl",
        "extensions.bzl",
        "providers.bzl",
        "rules.bzl",
        "shader_group.bzl",
        "toolchains.bzl",
    ],
    visibility = ["//docs:__subpackages__"],
    deps = ["//vulkan/private:bzl_lib"],
)
