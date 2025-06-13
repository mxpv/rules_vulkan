"""
Slang Toolchain
"""

SlangCompilerInfo = provider(
    doc = """Information about Slang compiler""",
    fields = ["compiler", "env"],
)

def _slang_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        info = SlangCompilerInfo(
            compiler = ctx.executable.compiler,
            env = ctx.attr.env,
        ),
    )

    return [toolchain_info]

slang_toolchain = rule(
    implementation = _slang_toolchain_impl,
    attrs = {
        "compiler": attr.label(
            executable = True,
            mandatory = True,
            cfg = "exec",
        ),
        "env": attr.string_dict(
            doc = """
            Environment variables to set for the Slang compiler.

            This can be used to set additional paths or configurations needed by the Slang compiler.
            """,
        ),
    },
)
