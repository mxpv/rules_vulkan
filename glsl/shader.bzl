"""
A rule to compile GLSL shaders.
"""

load("@bazel_skylib//lib:paths.bzl", "paths")

def _hlsl_shader_impl(ctx):
    glsl = ctx.toolchains["//glsl:toolchain_type"].glslinfo

    src = ctx.file.src

    # Declare output file
    out = ctx.attr.out
    if not out:
        out = paths.replace_extension(src.basename, ".cso")
    out = ctx.actions.declare_file(out)

    outs = [out]

    args = ctx.actions.args()

    args.add_all([
        "-o",
        out.path,
        "-fshader-stage={}".format(ctx.attr.stage),
    ])

    for define in ctx.attr.defines:
        args.append("-D{}".format(define))

    for path in ctx.attr.includes:
        args.add("-I")
        args.add(path)

    if ctx.attr.std:
        args.add("-std={}".format(ctx.attr.std))

    if ctx.attr.target_env:
        args.add("--target-env={}".format(ctx.attr.target_env))

    if ctx.attr.target_spv:
        args.add("--target-spv={}".format(ctx.attr.target_spv))

    # Append user-defined extra arguments
    args.add_all(ctx.attr.copts)

    args.add(src.path)

    ctx.actions.run(
        inputs = [src] + ctx.files.hdrs,
        outputs = outs,
        arguments = [args],
        executable = glsl.compiler,
        progress_message = "Compiling GLSL shader %s" % src.path,
        mnemonic = "GlslCompile",
    )

    return [DefaultInfo(files = depset([out]))]

glsl_shader = rule(
    implementation = _hlsl_shader_impl,
    doc = """
    Rule to compile GLSL shader.
    """,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "Input GLSL shader source to compile",
        ),
        "out": attr.string(
            doc = "Compiled shader output file. If not specified, defaults to the source file name with '.spv' extension",
        ),
        "stage": attr.string(
            mandatory = True,
            doc = "Shader stage (vertex, vert, fragment, frag, etc)",
        ),
        "includes": attr.string_list(
            doc = "Add directory to include search path to CLI",
        ),
        "hdrs": attr.label_list(
            allow_files = True,
            doc = "List of header files dependencies to be included in the shader compilation",
        ),
        "defines": attr.string_list(
            doc = "List of macro defines",
        ),
        "std": attr.string(
            doc = """
            Version and profile for GLSL input files.

            Possible values are concatenations of version and profile, e.g. `310es`, `450core`, etc.
            """,
        ),
        "target_env": attr.string(
            doc = """
            Set the target client environment, and the semantics of warnings and errors.

            An optional suffix can specify the client version.
            """,
        ),
        "target_spv": attr.string(
            doc = """
            Set the SPIR-V version to be used for the generated SPIR-V module.

            The default is the highest version of SPIR-V required to be supported for the target environment.
            For example, default for `vulkan1.0` is `spv1.0`.
            """,
        ),
        "copts": attr.string_list(
            doc = "Additional arguments to pass to the compiler",
        ),
    },
    toolchains = [":toolchain_type"],
)
