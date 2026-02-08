load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

exports_files(["versions.json"])

bzl_library(
    name = "bzl_lib",
    visibility = ["//visibility:public"],
    deps = ["@aspect_bazel_lib//lib:repo_utils"],
)

bzl_library(
    name = "download",
    srcs = ["download.bzl"],
    visibility = ["//vulkan:__subpackages__"],
    deps = [
        ":bzl_lib",
        ":resolve",
        "@aspect_bazel_lib//lib:repo_utils",
    ],
)

bzl_library(
    name = "glsl",
    srcs = ["glsl.bzl"],
    visibility = ["//vulkan:__subpackages__"],
    deps = [
        "//vulkan:providers",
        "@bazel_skylib//rules:common_settings",
    ],
)

bzl_library(
    name = "hlsl",
    srcs = ["hlsl.bzl"],
    visibility = ["//vulkan:__subpackages__"],
    deps = [
        "//vulkan:providers",
        "@bazel_skylib//rules:common_settings",
    ],
)

bzl_library(
    name = "shader_group",
    srcs = ["shader_group.bzl"],
    visibility = ["//vulkan:__subpackages__"],
    deps = [
        "//vulkan:providers",
        "@bazel_skylib//lib:paths",
        "@rules_pkg//pkg:providers.bzl",
    ],
)

bzl_library(
    name = "slang",
    srcs = ["slang.bzl"],
    visibility = ["//vulkan:__subpackages__"],
    deps = [
        "//vulkan:providers",
        "@bazel_skylib//rules:common_settings",
    ],
)

bzl_library(
    name = "spirv_cross",
    srcs = ["spirv_cross.bzl"],
    visibility = ["//vulkan:__subpackages__"],
    deps = ["//vulkan:providers"],
)

bzl_library(
    name = "resolve",
    srcs = ["resolve.bzl"],
    visibility = ["//vulkan:__subpackages__"],
    deps = [
        ":bzl_lib",
        "@aspect_bazel_lib//lib:repo_utils",
    ],
)
