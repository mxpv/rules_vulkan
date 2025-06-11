"""
A rule to compile HLSL shaders using DirectXShaderCompiler (dxc).
"""

def _hlsl_shader_impl(ctx):
    dxc = ctx.toolchains["//hlsl:toolchain_type"].hlslinfo
    out = ctx.actions.declare_file(ctx.label.name + ".cso")

    src = ctx.file.src
    entry = ctx.attr.entry
    target = ctx.attr.target

    args = [
        "-T",
        target,
        "-Fo",
        out.path,
    ]

    if entry:
        args += ["-E", entry]

    # Append macro defines
    for define in ctx.attr.defines:
        args += ["-D", define]

    for path in ctx.attr.includes:
        args += ["-I", path]

    if ctx.attr.hlsl_version:
        args += ["-HV", ctx.attr.hlsl_version]

    if ctx.attr.spirv:
        args.append("-spirv")

    # Append user-defined extra arguments
    args += ctx.attr.extra_args

    args.append(src.path)

    ctx.actions.run(
        inputs = [src],
        outputs = [out],
        arguments = args,
        executable = dxc.compiler,
        env = dxc.env,
        progress_message = "Compiling HLSL shader %s" % src.path,
        mnemonic = "HlslCompile",
    )

    return [DefaultInfo(files = depset([out]))]

hlsl_shader = rule(
    implementation = _hlsl_shader_impl,
    doc = """
    Rule to compile HLSL shaders using DirectXShaderCompiler.
    """,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "Input HLSL shader source file",
        ),
        "entry": attr.string(
            doc = "Entry point name",
        ),
        "target": attr.string(
            mandatory = True,
            doc = "Target profile (e.g., cs_6_0, ps_6_0, etc.)",
        ),
        "defines": attr.string_list(
            doc = "List of macro defines",
        ),
        "includes": attr.string_list(
            doc = "Add directory to include search path",
        ),
        "hlsl_version": attr.string(
            doc = "HLSL version to use (2016, 2017, 2018, 2021)",
        ),
        "spirv": attr.bool(
            doc = "Generate SPIR-V code",
        ),
        "extra_args": attr.string_list(
            doc = "Additional arguments to pass to the DXC compiler",
        ),
    },
    toolchains = [":toolchain_type"],
)
