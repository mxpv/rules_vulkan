load("@bazel_skylib//rules:native_binary.bzl", "native_binary")
load("@rules_cc//cc:cc_import.bzl", "cc_import")
load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_vulkan//glsl:toolchain.bzl", "glsl_toolchain")
load("@rules_vulkan//hlsl:toolchain.bzl", "hlsl_toolchain")
load("@rules_vulkan//slang:toolchain.bzl", "slang_toolchain")

package(default_visibility = ["//visibility:public"])

# Export SDK files to allow external wrappers.
exports_files(glob(
    [
        "sdk/bin/**",
        "sdk/Bin/**",
    ],
    allow_empty = True,
))

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
    # buildifier: disable=constant-glob
    srcs = glob(["{lib_vulkan}"]),
    hdrs = [":headers"],
    includes = ["{include_path}"],
    deps = [{vulkan_deps}],
)

#
# HLSL (dxc) toolchain
#

native_binary(
    name = "dxc",
    src = select({
        "@platforms//os:windows": "sdk/Bin/dxc.exe",
        "//conditions:default": "sdk/bin/dxc",
    }),
)

hlsl_toolchain(
    name = "dxc_{os}",
    compiler = ":dxc",
    env = select({
        "@platforms//os:windows": {
            "PATH": "{sdk_root}/Bin",
        },
        "//conditions:default": {},
    }),
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
    src = select({
        "@platforms//os:windows": "sdk/Bin/glslc.exe",
        "//conditions:default": "sdk/bin/glslc",
    }),
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
    src = select({
        "@platforms//os:windows": "sdk/Bin/slangc.exe",
        "//conditions:default": "sdk/bin/slangc",
    }),
)

slang_toolchain(
    name = "slang_{os}",
    compiler = ":slangc",
    env = select({
        "@platforms//os:windows": {
            "PATH": "{sdk_root}/Bin",
        },
        "@platforms//os:linux": {
            "LD_LIBRARY_PATH": "{sdk_root}/lib",
        },
        "//conditions:default": {},
    }),
)

toolchain(
    name = "slang_{os}_toolchain",
    exec_compatible_with = [
        "@platforms//os:{os}",
    ],
    toolchain = ":slang_{os}",
    toolchain_type = "@rules_vulkan//slang:toolchain_type",
)

#
# Spirv-cross
#

native_binary(
    name = "spirv_cross",
    src = select({
        "@platforms//os:windows": "sdk/Bin/spirv-cross.exe",
        "//conditions:default": "sdk/bin/spirv-cross",
    }),
)
