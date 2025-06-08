load("@bazel_skylib//rules:native_binary.bzl", "native_binary")
load("@rules_vulkan//hlsl:toolchain.bzl", "hlsl_toolchain")
load("@rules_vulkan//glsl:toolchain.bzl", "glsl_toolchain")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "headers",
    srcs = glob([
        "{include_path}/**/*.h",
        "{include_path}/**/*.hpp",
    ]),
)

# This uses workaround from https://github.com/bazelbuild/bazel/issues/4748
cc_library(
    name = "vulkan",
    srcs = glob(["{lib_vulkan}"]),
    hdrs = [":headers"],
    includes = ["{include_path}"],
)

#
# HLSL (dxc) toolchain
#

native_binary(
    name = "dxc",
    src = "{dxc_path}",
)

hlsl_toolchain(
    name = "dxc_{os}",
    compiler = ":dxc",
)

toolchain(
    name = "dxc_{os}_toolchain",
    exec_compatible_with = [
        "@platforms//os:{os}",
    ],
    toolchain = ":dxc_{os}",
    toolchain_type = "@rules_vulkan//hlsl:toolchain_type",
)

#
# GLSL toolchain
#

native_binary(
    name = "glslc",
    src = "{glslc_path}"
)

glsl_toolchain(
    name = "glsl_{os}",
    compiler = ":glslc",
)

toolchain(
    name = "glsl_{os}_toolchain",
    exec_compatible_with = [
        "@platforms//os:{os}",
    ],
    toolchain = ":glsl_{os}",
    toolchain_type = "@rules_vulkan//glsl:toolchain_type",
)

