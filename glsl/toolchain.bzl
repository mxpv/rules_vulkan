"""
GLSL Toolchain
"""

GlslCompilerInfo = provider(
    doc = "Information about GLSL compiler",
    fields = ["compiler"],
)

def _glsl_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        info = GlslCompilerInfo(
            compiler = ctx.executable.compiler,
        ),
    )

    return [toolchain_info]

glsl_toolchain = rule(
    implementation = _glsl_toolchain_impl,
    doc = """
    GLSL Toolchain
    """,
    attrs = {
        "compiler": attr.label(
            executable = True,
            mandatory = True,
            cfg = "exec",
            doc = "Path to compiler executable",
        ),
    },
)
