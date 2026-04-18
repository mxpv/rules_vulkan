load("@bazel_skylib//rules:native_binary.bzl", "native_binary")
load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_pkg//:pkg.bzl", "pkg_zip")
load("@rules_vulkan//vulkan:defs.bzl", "glsl_shader", "hlsl_shader", "shader_group", "slang_shader", "spirv_cross")
load("@vk_sdk//:env.bzl", "MOLTENVK_ICD", "VALIDATION_LAYER_PATH", "VULKAN_SDK")
load(":metadata.bzl", "gather_metadata")

hlsl_shader(
    name = "hello_hlsl",
    src = "shader.hlsl",
    hdrs = ["//common:common_headers"],
    asm = "hello_hlsl.asm",  # Output assembly code
    defines = ["USE_VULKAN"],
    entry = "CSMain",
    opts = [
        "-HV",
        "2021",
        "-Ges",
        "-spirv",
    ],
    target = "cs_6_0",
)

spirv_cross(
    name = "hello_msl",
    src = ":hello_hlsl",
    backend = "msl",
    # entry point and stage will be injected automatically.
    opts = [
        "--msl-version",
        "20100",
    ],
)

slang_shader(
    name = "hello_slang",
    srcs = ["shader.hlsl"],
    hdrs = ["//common:common_headers"],
    defines = ["USE_VULKAN"],
    depfile = "hello_slang.dep",
    entry = "CSMain",
    lang = "hlsl",
    opts = [
        "-warnings-as-errors",
        "all",
    ],
    profile = "glsl_450",
    reflect = "hello_slang.json",
    stage = "compute",
    target = "spirv",
)

glsl_shader(
    name = "hello_glsl",
    src = "shader.glsl",
    hdrs = ["//common:common_headers"],
    stage = "comp",
    std = "450core",
    target_env = "vulkan1.4",
    target_spv = "spv1.6",
)

shader_group(
    name = "all_shaders",
    # Shader groups play nicely with `rules_pkg` and allow specifying location inside of an archive.
    # See https://github.com/bazelbuild/rules_pkg/blob/main/docs/0.10.0/reference.md#pkg_files-prefix
    # Essentially, shader groups can be used inplace of `pkg_files` to bundle shader outputs.
    pkg_prefix = "shaders/",
    deps = [
        ":hello_glsl",
        ":hello_hlsl",
        ":hello_msl",
        ":hello_slang",
    ],
)

# Since the SDK repo exports all binaries, you can manually wrap any SDK binary not directly exposed
native_binary(
    name = "spirv_cross",
    src = select({
        "@platforms//os:windows": "@vk_sdk//:sdk/Bin/spirv-cross.exe",
        "//conditions:default": "@vk_sdk//:sdk/bin/spirv-cross",
    }),
)

gather_metadata(
    name = "metadata",
    out = "metadata.json",
    deps = [":all_shaders"],
)

# This produces a new ZIP archive with metadata.json at root and ./shaders subdirectory with all shader outputs.
pkg_zip(
    name = "database",
    srcs = [
        ":all_shaders",
        ":metadata",
    ],
    out = "database.zip",
    compression_level = 0,  # Don't compress, just bundle files.
)

_VULKAN_ENV = {
    "VULKAN_SDK": VULKAN_SDK,
    "VK_ADD_LAYER_PATH": VALIDATION_LAYER_PATH,
} | select({
    "@platforms//os:macos": {"VK_DRIVER_FILES": MOLTENVK_ICD},
    "@platforms//os:linux": {"LD_LIBRARY_PATH": VULKAN_SDK + "/lib"},
    "//conditions:default": {},
})

cc_binary(
    name = "app",
    srcs = ["main.c"],
    data = [
        ":database",
    ],
    env = _VULKAN_ENV,
    deps = ["@vk_sdk//:vulkan"],
)

cc_binary(
    name = "volk_app",
    srcs = ["volk_test.c"],
    env = select({
        "@platforms//os:linux": {"LD_LIBRARY_PATH": VULKAN_SDK + "/lib"},
        "//conditions:default": {},
    }),
    # Volk loads the Vulkan loader at runtime via dlopen("libvulkan.dylib").
    # Add the SDK lib directory to rpath so the dynamic linker can find it.
    linkopts = select({
        "@platforms//os:macos": ["-Wl,-rpath," + VULKAN_SDK + "/lib"],
        "//conditions:default": [],
    }),
    deps = ["@vk_sdk//:volk"],
)
