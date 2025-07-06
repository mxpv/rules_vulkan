load("@bazel_skylib//:bzl_library.bzl", "bzl_library")
load("@bazel_skylib//rules:common_settings.bzl", "string_list_flag")

string_list_flag(
    name = "extra_opts",
    build_setting_default = [],
    visibility = ["//visibility:public"],
)

bzl_library(
    name = "bzl_lib",
    srcs = [
        "rules.bzl",
        "toolchain.bzl",
    ],
    visibility = ["//docs:__subpackages__"],
)
