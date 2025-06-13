"""
A rule to compile HLSL shaders using DirectXShaderCompiler (dxc).
"""

load("@bazel_skylib//lib:paths.bzl", "paths")

def _hlsl_shader_impl(ctx):
    dxc = ctx.toolchains["//hlsl:toolchain_type"].info
    src = ctx.file.src

    # Declare output file
    out = ctx.attr.out
    if not out:
        out = paths.replace_extension(src.basename, ".cso")
    out = ctx.actions.declare_file(out)

    outs = [out]

    entry = ctx.attr.entry
    target = ctx.attr.target

    args = ctx.actions.args()

    # Target + shader output path (required).
    args.add_all(["-T", target, "-Fo", out.path])

    # Entry point
    if entry:
        args.add("-E")
        args.add(entry)

    # Append macro defines
    for define in ctx.attr.defines:
        args.add("-D")
        args.add(define)

    for path in ctx.attr.includes:
        args.add("-I")
        args.add(path)

    # Specify HLSL version
    if ctx.attr.hlsl:
        args.add("-HV")
        args.add(ctx.attr.hlsl)

    # Specify root signature from #define
    if ctx.attr.root_sig:
        args.add("-rootsig-define")
        args.add(ctx.attr.root_sig)

    # Output assembly code
    if ctx.attr.out_asm:
        out_asm = ctx.actions.declare_file(ctx.attr.out_asm)
        args.add("-Fc")
        args.add(out_asm)
        outs.append(out_asm)

    # Reflect shader
    if ctx.attr.out_reflect:
        out_reflect = ctx.actions.declare_file(ctx.attr.out_reflect)
        args.add("-Fre")
        args.add(out_reflect)
        outs.append(out_reflect)

    if ctx.attr.out_hash:
        out_hash = ctx.actions.declare_file(ctx.attr.out_hash)
        args.add("-Fsh")
        args.add(out_hash)
        outs.append(out_hash)

    if ctx.attr.spirv:
        args.add("-spirv")

    # Append user-defined extra arguments
    args.add_all(ctx.attr.copts)

    # Output bytecode file path.
    args.add(src.path)

    ctx.actions.run(
        inputs = [src] + ctx.files.hdrs,
        outputs = outs,
        arguments = [args],
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
        "out": attr.string(
            doc = "Compiled shader output file. If not specified, defaults to the source file name with '.cso' extension",
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
            doc = "List of directories to be added to the CLI to search for include files",
        ),
        "hdrs": attr.label_list(
            allow_files = True,
            doc = "List of header files dependencies to be included in the shader compilation",
        ),
        "hlsl": attr.string(
            doc = "HLSL version to use (2016, 2017, 2018, 2021)",
        ),
        "root_sig": attr.string(
            doc = "Read root signature from a #define (-rootsig-define <value>)",
        ),
        "spirv": attr.bool(
            doc = "Generate SPIR-V code",
        ),
        "copts": attr.string_list(
            doc = "Additional arguments to pass to the DXC compiler",
        ),
        "out_asm": attr.string(
            doc = "Output assembly code listing file (-Fc <file>)",
        ),
        "out_reflect": attr.string(
            doc = "Output reflection to the given file (-Fre <file>)",
        ),
        "out_hash": attr.string(
            doc = "Output shader hash to the given file (-Fsh <file>)",
        ),
    },
    toolchains = [":toolchain_type"],
)
