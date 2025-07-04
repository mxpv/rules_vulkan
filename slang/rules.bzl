"""
A rule to compile Slang shaders.
"""

load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("//vulkan:providers.bzl", "ShaderInfo")

def _slang_shader_impl(ctx):
    slang = ctx.toolchains["//slang:toolchain_type"].info

    out_obj = ctx.actions.declare_file(ctx.label.name + ".out")
    outs = [out_obj]

    args = ctx.actions.args()
    args.add_all([
        "-profile",
        ctx.attr.profile,
        "-target",
        ctx.attr.target,
        "-o",
        out_obj.path,
    ])

    if ctx.attr.stage:
        args.add("-stage", ctx.attr.stage)

    if ctx.attr.entry:
        args.add("-entry", ctx.attr.entry)

    if ctx.attr.lang:
        args.add("-lang", ctx.attr.lang)

    for define in ctx.attr.defines:
        args.add("-D", define)

    for path in ctx.attr.includes:
        args.add("-I", path)

    # Emit reflection data to a file
    if ctx.attr.reflect:
        out = ctx.actions.declare_file(ctx.label.name + ".json")
        args.add("-reflection-json", out.path)
        outs.append(out)

    if ctx.attr.depfile:
        out = ctx.actions.declare_file(ctx.label.name + ".dep")
        args.add("-depfile", out.path)
        outs.append(out)

    # Append user-defined extra arguments
    args.add_all(ctx.attr.opts)

    # Append build settings options.
    extra_opts = ctx.attr._extra_opts[BuildSettingInfo].value
    args.add_all(extra_opts, uniquify = True)

    # Input shader source file
    args.add_all(ctx.files.srcs)

    ctx.actions.run(
        inputs = ctx.files.srcs + ctx.files.hdrs,
        outputs = outs,
        arguments = [args],
        executable = slang.compiler,
        env = slang.env,
        progress_message = "Compiling Slang shader %s" % ", ".join([f.short_path for f in ctx.files.srcs]),
        mnemonic = "SlangCompile",
    )

    return [
        DefaultInfo(files = depset(outs)),
        ShaderInfo(
            label = str(ctx.label),
            entry = ctx.attr.entry,
            outs = [f.short_path for f in outs],
            stage = ctx.attr.stage,
            defines = ctx.attr.defines,
            target = ctx.attr.target,
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
        "reflect": attr.bool(
            doc = "Emit reflection data in JSON format to a file <name>.json",
        ),
        "depfile": attr.bool(
            doc = "Save the source file dependency list in a file (-depfile <name>.dep)",
        ),
        "entry": attr.string(
            doc = "Entry point name",
        ),
        "includes": attr.string_list(
            doc = "Add a path to CLI to be used to search #include or #import operations",
        ),
        "hdrs": attr.label_list(
            allow_files = True,
            doc = "List of header files dependencies to be included in the shader compilation",
        ),
        "defines": attr.string_list(
            doc = "Insert a preprocessor macro",
        ),
        "stage": attr.string(
            doc = "Stage of an entry point function (vertex, pixel, compute, etc)",
        ),
        "profile": attr.string(
            mandatory = True,
            doc = "Shader profile for code generation (sm_6_6, vs_6_6, glsl_460, etc)",
        ),
        "target": attr.string(
            mandatory = True,
            doc = "Format in which code should be generated (hlsl, dxil, dxil-asm, glsl, spirv, metal, metallib, etc)",
        ),
        "lang": attr.string(
            doc = "Set source language for the shader (slang, hlsl, glsl, cpp, etc)",
        ),
        "opts": attr.string_list(
            doc = "Additional arguments to pass to the compiler",
        ),
        "_extra_opts": attr.label(
            default = ":extra_opts",
            doc = "Add extra options provided via Bazel's build settings.",
        ),
    },
    toolchains = [":toolchain_type"],
    provides = [ShaderInfo],
)
