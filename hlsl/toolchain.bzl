HlslInfo = provider(
    doc = """Information about HLSL compiler""",
    fields = ["compiler"],
)

def _hlsl_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        hlslinfo = HlslInfo(
            compiler = ctx.executable.compiler,
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
        ),
    },
)
