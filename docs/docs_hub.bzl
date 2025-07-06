"""
All project entries to generate documentation for.
"""

load("//vulkan:defs.bzl", _download_sdk = "download_sdk", _glsl_shader = "glsl_shader", _hlsl_shader = "hlsl_shader", _shader_group = "shader_group", _slang_shader = "slang_shader")
load("//vulkan:providers.bzl", _ShaderGroupInfo = "ShaderGroupInfo", _ShderInfo = "ShaderInfo")
load("//vulkan:toolchains.bzl", _VulkanInfo = "VulkanInfo")

glsl_shader = _glsl_shader
hlsl_shader = _hlsl_shader
slang_shader = _slang_shader

download_sdk = _download_sdk

VulkanInfo = _VulkanInfo
ShaderInfo = _ShderInfo
ShaderGroupInfo = _ShaderGroupInfo

shader_group = _shader_group
