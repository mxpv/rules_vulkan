load("//glsl:shader.bzl", _glsl_shader = "glsl_shader")
load("//glsl:toolchain.bzl", _glsl_toolchain = "glsl_toolchain")
load("//hlsl:shader.bzl", _hlsl_shader = "hlsl_shader")
load("//hlsl:toolchain.bzl", _hlsl_toolchain = "hlsl_toolchain")
load("//slang:shader.bzl", _slang_shader = "slang_shader")
load("//slang:toolchain.bzl", _slang_toolchain = "slang_toolchain")
load("//vulkan:defs.bzl", _download_sdk = "download_sdk")

glsl_shader = _glsl_shader
glsl_toolchain = _glsl_toolchain

hlsl_shader = _hlsl_shader
hlsl_toolchain = _hlsl_toolchain

slang_shader = _slang_shader
slang_toolchain = _slang_toolchain

download_sdk = _download_sdk
