load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

bzl_library(
    name = "bzl_lib",
    srcs = [
        "shader.bzl",
        "toolchain.bzl",
    ],
    visibility = ["//docs:__subpackages__"],
)
