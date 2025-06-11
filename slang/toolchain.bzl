"""
Slang Toolchain
"""

SlangInfo = provider(
    doc = """Information about Slang compiler""",
    fields = ["compiler", "lib_path"],
)

def _slang_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        slanginfo = SlangInfo(
            compiler = ctx.executable.compiler,
            lib_path = ctx.attr.lib_path,
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
        "lib_path": attr.string(
            doc = """
            Absolute path to Vulkan SDK lib directory.

            This will be added to `LD_LIBRARY_PATH`.
            """,
        ),
    },
)
