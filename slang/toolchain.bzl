"""
Slang Toolchain
"""

SlangInfo = provider(
    doc = """Information about Slang compiler""",
    fields = ["compiler"],
)

def _slang_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        slanginfo = SlangInfo(
            compiler = ctx.executable.compiler,
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
    },
)
