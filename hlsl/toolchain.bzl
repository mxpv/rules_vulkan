"""
HLSL Toolchain
"""

HlslInfo = provider(
    doc = """Information about HLSL compiler""",
    fields = ["compiler", "env"],
)

def _hlsl_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        hlslinfo = HlslInfo(
            compiler = ctx.executable.compiler,
            env = ctx.attr.env,
        ),
    )

    return [toolchain_info]

hlsl_toolchain = rule(
    implementation = _hlsl_toolchain_impl,
    attrs = {
        "compiler": attr.label(
            executable = True,
            mandatory = True,
            cfg = "exec",
            doc = "Path to the HLSL compiler executable (e.g., dxc)",
        ),
        "env": attr.string_dict(
            doc = """
            Environment variables to set for the HLSL compiler.

            This can be used to set additional paths or configurations needed by the HLSL compiler.
            """,
        ),
    },
)
