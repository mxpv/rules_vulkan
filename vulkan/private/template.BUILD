load("@bazel_skylib//rules:native_binary.bzl", "native_binary")
load("@rules_vulkan//hlsl:toolchain.bzl", "hlsl_toolchain")
load("@rules_vulkan//glsl:toolchain.bzl", "glsl_toolchain")
load("@rules_vulkan//slang:toolchain.bzl", "slang_toolchain")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "headers",
    srcs = glob([
        "{include_path}/**/*.h",
        "{include_path}/**/*.hpp",
    ]),
)

cc_import(
    name = "vulkan_dll",
    shared_library = "vulkan-1.dll",
    target_compatible_with = [
        "@platforms//os:windows",
    ],
)

# This uses workaround from https://github.com/bazelbuild/bazel/issues/4748
cc_library(
    name = "vulkan",
    srcs = glob(["{lib_vulkan}"]),
    hdrs = [":headers"],
    includes = ["{include_path}"],
    deps = [{vulkan_deps}]
)

#
# HLSL (dxc) toolchain
#

native_binary(
    name = "dxc",
    src = "{bin_dxc}",
)

hlsl_toolchain(
    name = "dxc_{os}",
    compiler = ":dxc",
    env = { {dxc_env} },
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
    src = "{bin_glslc}"
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

#
# Slang toolchain
#

native_binary(
    name = "slangc",
    src = "{bin_slangc}"
)

slang_toolchain(
    name = "slang_{os}",
    compiler = ":slangc",
    env = { {slang_env} },
)

toolchain(
    name = "slang_{os}_toolchain",
    exec_compatible_with = [
        "@platforms//os:{os}",
    ],
    toolchain = ":slang_{os}",
    toolchain_type = "@rules_vulkan//slang:toolchain_type",
)

