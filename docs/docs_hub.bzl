"""
All project entries to generate documentation for.
"""

load("//glsl:rules.bzl", _glsl_shader = "glsl_shader")
load("//glsl:toolchain.bzl", _GlslCompilerInfo = "GlslCompilerInfo", _glsl_toolchain = "glsl_toolchain")
load("//hlsl:rules.bzl", _hlsl_shader = "hlsl_shader")
load("//hlsl:toolchain.bzl", _HlslCompilerInfo = "HlslCompilerInfo", _hlsl_toolchain = "hlsl_toolchain")
load("//slang:rules.bzl", _slang_shader = "slang_shader")
load("//slang:toolchain.bzl", _SlangCompilerInfo = "SlangCompilerInfo", _slang_toolchain = "slang_toolchain")
load("//vulkan:defs.bzl", _download_sdk = "download_sdk")
load("//vulkan:providers.bzl", _ShaderGroupInfo = "ShaderGroupInfo", _ShderInfo = "ShaderInfo")
load("//vulkan:rules.bzl", _shader_group = "shader_group")

glsl_shader = _glsl_shader
glsl_toolchain = _glsl_toolchain
GlslCompilerInfo = _GlslCompilerInfo

hlsl_shader = _hlsl_shader
hlsl_toolchain = _hlsl_toolchain
HlslCompilerInfo = _HlslCompilerInfo

slang_shader = _slang_shader
slang_toolchain = _slang_toolchain
SlangCompilerInfo = _SlangCompilerInfo

download_sdk = _download_sdk

ShaderInfo = _ShderInfo
ShaderGroupInfo = _ShaderGroupInfo

shader_group = _shader_group
