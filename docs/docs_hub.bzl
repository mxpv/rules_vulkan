"""
All project entries to generate documentation for.
"""

load("//glsl:rules.bzl", _glsl_shader = "glsl_shader")
load("//hlsl:rules.bzl", _hlsl_shader = "hlsl_shader")
load("//slang:rules.bzl", _slang_shader = "slang_shader")
load("//vulkan:defs.bzl", _download_sdk = "download_sdk")
load("//vulkan:providers.bzl", _ShaderGroupInfo = "ShaderGroupInfo", _ShderInfo = "ShaderInfo")
load("//vulkan:rules.bzl", _shader_group = "shader_group")
load("//vulkan:toolchains.bzl", _VulkanInfo = "VulkanInfo")

glsl_shader = _glsl_shader
hlsl_shader = _hlsl_shader
slang_shader = _slang_shader

VulkanInfo = _VulkanInfo

download_sdk = _download_sdk

ShaderInfo = _ShderInfo
ShaderGroupInfo = _ShaderGroupInfo

shader_group = _shader_group
