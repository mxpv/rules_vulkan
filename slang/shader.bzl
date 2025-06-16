"""
A rule to compile Slang shaders.
"""

load("@bazel_skylib//lib:paths.bzl", "paths")
load("//vulkan:providers.bzl", "ShaderInfo")

def _slang_shader_impl(ctx):
    slang = ctx.toolchains["//slang:toolchain_type"].info

    src = ctx.file.src

    # Declare output file
    out = ctx.attr.out
    if not out:
        out = paths.replace_extension(src.basename, ".out")
    out = ctx.actions.declare_file(out)

    outs = [out]

    args = ctx.actions.args()
    args.add_all([
        "-profile",
        ctx.attr.profile,
        "-target",
        ctx.attr.target,
        "-o",
        out.path,
    ])

    if ctx.attr.stage:
        args.add("-stage")
        args.add(ctx.attr.stage)

    if ctx.attr.entry:
        args.add("-entry")
        args.add(ctx.attr.entry)

    if ctx.attr.lang:
        args.add("-lang")
        args.add(ctx.attr.lang)

    for define in ctx.attr.defines:
        args.add("-D")
        args.add(define)

    for path in ctx.attr.includes:
        args.add("-I")
        args.add(path)

    # Emit reflection data to a file
    if ctx.attr.out_reflect:
        out_reflect = ctx.actions.declare_file(ctx.attr.out_reflect)
        args.add("-reflection-json")
        args.add(out_reflect)
        outs.append(out_reflect)

    # Input shader source file
    args.add(src.path)

    ctx.actions.run(
        inputs = [src] + ctx.files.hdrs,
        outputs = outs,
        arguments = [args],
        executable = slang.compiler,
        env = slang.env,
        progress_message = "Compiling Slang shader %s" % src.path,
        mnemonic = "SlangCompile",
    )

    return [
        DefaultInfo(files = depset(outs)),
        ShaderInfo(
            label = str(ctx.label),
            entry = ctx.attr.entry or "main",
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
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "Input shader source to compile",
        ),
        "out": attr.string(
            doc = "Compiled shader output file. If not specified, defaults to the source file name with '.out' extension",
        ),
        "out_reflect": attr.string(
            doc = "Emit reflection data in JSON format to a file",
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
            doc = "Shader profile for code generation",
        ),
        "target": attr.string(
            mandatory = True,
            doc = "Format in which code should be generated",
        ),
        "lang": attr.string(
            doc = "Set language for the shader",
        ),
        "copts": attr.string_list(
            doc = "Additional arguments to pass to the compiler",
        ),
    },
    toolchains = [":toolchain_type"],
    provides = [ShaderInfo],
)
