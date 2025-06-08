"""
Rule to compile GLSL shaders.
"""

def _hlsl_shader_impl(ctx):
    glsl = ctx.toolchains["//glsl:toolchain_type"].glslinfo

    out = ctx.actions.declare_file(ctx.label.name + ".spv")
    src = ctx.file.src

    args = [
        "-o",
        out.path,
    ]

    for define in ctx.attr.defines:
        args.append("-D{}".format(define))

    for path in ctx.attr.includes:
        args += ["-I", path]

    # Append user-defined extra arguments
    args += ctx.attr.extra_args

    args.append(src.path)

    ctx.actions.run(
        inputs = [src],
        outputs = [out],
        arguments = args,
        executable = glsl.compiler,
        progress_message = "Compiling GLSL shader %s" % src.path,
        mnemonic = "GlslCompile",
    )

    return [DefaultInfo(files = depset([out]))]

glsl_shader = rule(
    implementation = _hlsl_shader_impl,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "Input GLSL shader source to compile",
        ),
        "includes": attr.string_list(
            doc = "Add directory to include search path",
        ),
        "defines": attr.string_list(
            doc = "List of macro defines",
        ),
        "extra_args": attr.string_list(
            doc = "Additional arguments to pass to the compiler",
        ),
    },
    toolchains = [":toolchain_type"],
)
