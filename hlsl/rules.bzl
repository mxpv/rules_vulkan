"""
A rule to compile HLSL shaders using DirectXShaderCompiler (dxc).
"""

load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("//vulkan:providers.bzl", "ShaderInfo")

def _map_stage(target):
    if target.startswith("vs"):
        return "vertex"
    elif target.startswith("ps"):
        return "pixel"
    elif target.startswith("cs"):
        return "compute"
    elif target.startswith("gs"):
        return "geometry"
    elif target.startswith("hs"):
        return "hull"
    elif target.startswith("ds"):
        return "domain"
    elif target.startswith("ms"):
        return "mesh"
    elif target.startswith("as"):
        return "amplification"
    else:
        return "unknown"

def _hlsl_shader_impl(ctx):
    dxc = ctx.toolchains["//hlsl:toolchain_type"].info

    ext = ".spv" if ctx.attr.spirv else ".cso"
    out_obj = ctx.actions.declare_file(ctx.label.name + ext)
    outs = [out_obj]

    args = ctx.actions.args()

    # Target + shader output path (required).
    args.add_all(["-T", ctx.attr.target, "-Fo", out_obj.path])

    # Entry point
    if ctx.attr.entry:
        args.add("-E", ctx.attr.entry)

    # Append macro defines
    for define in ctx.attr.defines:
        args.add("-D", define)

    for path in ctx.attr.includes:
        args.add("-I", path)

    # Specify HLSL version
    if ctx.attr.hlsl:
        args.add("-HV", ctx.attr.hlsl)

    # Specify root signature from #define
    if ctx.attr.def_root_sig:
        args.add("-rootsig-define", ctx.attr.def_root_sig)

    # Output assembly code
    if ctx.attr.asm:
        out = ctx.actions.declare_file(ctx.label.name + ".asm")
        args.add("-Fc", out)
        outs.append(out)

    # Output reflection
    if ctx.attr.reflect:
        out = ctx.actions.declare_file(ctx.label.name + ".reflect")
        args.add("-Fre", out)
        outs.append(out)

    # Output hash.
    if ctx.attr.hash:
        out = ctx.actions.declare_file(ctx.label.name + ".hash")
        args.add("-Fsh", out)
        outs.append(out)

    if ctx.attr.spirv:
        args.add("-spirv")

    # Append user-defined extra arguments
    args.add_all(ctx.attr.opts)

    # Append build settings options.
    extra_opts = ctx.attr._extra_opts[BuildSettingInfo].value
    args.add_all(extra_opts, uniquify = True)

    # Specify input shader source file
    src = ctx.file.src
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

    return [
        DefaultInfo(files = depset(outs)),
        ShaderInfo(
            label = str(ctx.label),
            entry = ctx.attr.entry,
            outs = [f.short_path for f in outs],
            stage = _map_stage(ctx.attr.target),
            defines = ctx.attr.defines,
            target = ctx.attr.target,
        ),
    ]

hlsl_shader = rule(
    implementation = _hlsl_shader_impl,
    doc = """
    Rule to compile HLSL shaders using DirectXShaderCompiler.

    The target will output <name>.cso or <name>.spv (when targeting spirv) file with bytecode output.
    """,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "Input HLSL shader source file",
        ),
        "entry": attr.string(
            default = "main",
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
        "def_root_sig": attr.string(
            doc = "Read root signature from a #define (-rootsig-define <value>)",
        ),
        "spirv": attr.bool(
            doc = "Generate SPIR-V code",
        ),
        "opts": attr.string_list(
            doc = "Additional arguments to pass to the DXC compiler",
        ),
        "asm": attr.bool(
            doc = "Output assembly code listing file (-Fc <file>). This will produce <name>.asm file",
        ),
        "reflect": attr.bool(
            doc = "Output reflection to the given file (-Fre <file>). This will produce <name>.reflect file",
        ),
        "hash": attr.bool(
            doc = "Output shader hash to the given file (-Fsh <file>). This will produce <name>.hash file",
        ),
        "_extra_opts": attr.label(
            default = ":extra_opts",
            doc = "Add extra options provided via Bazel's build settings.",
        ),
    },
    toolchains = [":toolchain_type"],
    provides = [ShaderInfo],
)
