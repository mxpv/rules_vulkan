"""
A rule to compile Slang shaders.
"""

load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("//vulkan:providers.bzl", "ShaderInfo")
load("//vulkan/private:common.bzl", "resolve_includes")

def _slang_shader_impl(ctx):
    sdk = ctx.toolchains["//vulkan:toolchain_type"].info

    name = ctx.attr.out if ctx.attr.out else ctx.label.name + ".out"
    compiled_file = ctx.actions.declare_file(name)
    all_files = [compiled_file]

    args = ctx.actions.args()
    if ctx.attr.profile:
        args.add("-profile", ctx.attr.profile)
    if ctx.attr.target:
        args.add("-target", ctx.attr.target)

    args.add("-o", compiled_file)

    if ctx.attr.stage:
        args.add("-stage", ctx.attr.stage)

    if ctx.attr.entry:
        args.add("-entry", ctx.attr.entry)

    if ctx.attr.lang:
        args.add("-lang", ctx.attr.lang)

    for define in ctx.attr.defines:
        args.add("-D", define)

    for include in resolve_includes(ctx):
        args.add("-I", include)

    # Emit reflection data to a file
    reflection_file = None
    if ctx.attr.reflect:
        reflection_file = ctx.actions.declare_file(ctx.attr.reflect)
        args.add("-reflection-json", reflection_file.path)
        all_files.append(reflection_file)

    depfile_file = None
    if ctx.attr.depfile:
        depfile_file = ctx.actions.declare_file(ctx.attr.depfile)
        args.add("-depfile", depfile_file.path)
        all_files.append(depfile_file)

    # Append user-defined extra arguments
    args.add_all(ctx.attr.opts)

    # Append build settings options.
    extra_opts = ctx.attr._extra_opts[BuildSettingInfo].value
    args.add_all(extra_opts)

    # Input shader source file
    args.add_all(ctx.files.srcs)

    ctx.actions.run(
        inputs = ctx.files.srcs + ctx.files.hdrs,
        outputs = all_files,
        arguments = [args],
        executable = sdk.slangc,
        env = sdk.env,
        progress_message = "Compiling Slang shader %s" % ", ".join([f.short_path for f in ctx.files.srcs]),
        mnemonic = "SlangCompile",
    )

    return [
        DefaultInfo(
            files = depset([compiled_file]),
        ),
        OutputGroupInfo(
            all_files = depset(all_files),
        ),
        ShaderInfo(
            binary = compiled_file,
            entry = ctx.attr.entry,
            assembly = None,
            reflection = reflection_file if reflection_file else None,
            hash = None,
            depfile = depfile_file if depfile_file else None,
            stage = ctx.attr.stage,
            defines = ctx.attr.defines,
            target = ctx.attr.target if ctx.attr.target else None,
        ),
    ]

slang_shader = rule(
    implementation = _slang_shader_impl,
    doc = """
    Rule to compile Slang shaders.
    """,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "Slang input shader files",
        ),
        "out": attr.string(
            doc = "Specify a path where generated output should be written (-o <path>)",
        ),
        "reflect": attr.string(
            doc = "Emit reflection data in JSON format to a file",
        ),
        "depfile": attr.string(
            doc = "Save the source file dependency list in a file (-depfile <name>.dep)",
        ),
        "entry": attr.string(
            doc = "Entry point name",
        ),
        "includes": attr.string_list(
            doc = """List of include search directories, resolved relative to the package.

            Each entry produces two `-I` flags:

            - Source tree path (e.g. `foo/bar/common`) — for headers checked into the repository, when the include
              path you need differs from the directory that `hdrs` would auto-derive. For example, with a header at
              `pkg/common/nested/helper.h` and `#include "nested/helper.h"`, `hdrs` auto-derives
              `-I pkg/common/nested` but you actually need `-I pkg/common`. Adding `includes = ["common"]` provides
              that.
            - Bin directory path (e.g. `bazel-out/.../bin/foo/bar/common`) — same as above, but for headers generated
              by other rules (e.g. `genrule`), which are placed under the output directory rather than the source
              tree.

            Paths are constructed by joining the package path with the entry value (e.g. an entry `"common"` in
            package `foo/bar` resolves to `foo/bar/common`).

            Use this when the auto-derived paths from `hdrs` are not sufficient — for example, when the `#include`
            directive uses a path prefix that differs from the header file's immediate directory
            (e.g. `#include "subdir/header.h"` where the header is at `pkg/subdir/header.h` and `-I pkg` is needed).
            """,
        ),
        "hdrs": attr.label_list(
            allow_files = True,
            doc = """List of header file dependencies for shader compilation.

            Each unique directory containing a header file automatically generates a `-I` flag, so the compiler can
            find headers included by filename (e.g. `#include "common.h"`). These files are also added as action
            inputs so that Bazel tracks them as dependencies and triggers rebuilds when they change.
            """,
        ),
        "defines": attr.string_list(
            doc = "Insert a preprocessor macro",
        ),
        "stage": attr.string(
            doc = "Stage of an entry point function (vertex, pixel, compute, etc)",
        ),
        "profile": attr.string(
            doc = "Shader profile for code generation (sm_6_6, vs_6_6, glsl_460, etc)",
        ),
        "target": attr.string(
            doc = """Format in which code should be generated (hlsl, dxil, dxil-asm, glsl, spirv, metal, metallib, etc).
            This field is optional when compiling to a Slang IR module with `-emit-ir`. When omitted, the `target`
            field in `ShaderInfo` will be `None`.""",
        ),
        "lang": attr.string(
            doc = "Set source language for the shader (slang, hlsl, glsl, cpp, etc)",
        ),
        "opts": attr.string_list(
            doc = """Additional arguments to pass to the compiler.

            Flags from `//vulkan/settings:slangc_opts` are appended after these, so the global build setting takes
            precedence on conflicting flags.
            """,
        ),
        "_extra_opts": attr.label(
            default = "//vulkan/settings:slangc_opts",
            doc = "Add extra options provided via Bazel's build settings.",
        ),
    },
    toolchains = ["//vulkan:toolchain_type"],
    provides = [ShaderInfo],
)
