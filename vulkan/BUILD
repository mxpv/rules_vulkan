load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

bzl_library(
    name = "bzl_lib",
    srcs = ["defs.bzl", "extensions.bzl"],
    visibility = ["//docs:__subpackages__"],
    deps = ["//vulkan/private:bzl_lib"]
)
