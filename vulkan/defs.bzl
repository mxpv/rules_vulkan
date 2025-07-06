"""
Definitions for the Vulkan SDK Bazel rules.
"""

load("//vulkan/private:download.bzl", _download_sdk = "download_sdk")
load("//vulkan/private:glsl.bzl", _glsl_shader = "glsl_shader")
load("//vulkan/private:hlsl.bzl", _hlsl_shader = "hlsl_shader")
load("//vulkan/private:shader_group.bzl", _shader_group = "shader_group")
load("//vulkan/private:slang.bzl", _slang_shader = "slang_shader")
load("//vulkan/private:versions.bzl", _VERSIONS = "VERSIONS")

download_sdk = _download_sdk

VERSIONS = _VERSIONS

hlsl_shader = _hlsl_shader
slang_shader = _slang_shader
glsl_shader = _glsl_shader
shader_group = _shader_group
