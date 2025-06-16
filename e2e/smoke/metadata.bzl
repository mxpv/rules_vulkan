"""
An example how to aggregate information from a group of shaders.
"""

load("@rules_vulkan//vulkan:providers.bzl", "ShaderGroupInfo", "ShaderInfo")

def _shader_metadata_impl(ctx):
    infos = []
    files = []

    for dep in ctx.attr.deps:
        if ShaderInfo in dep:
            infos.append(dep[ShaderInfo])
        elif ShaderGroupInfo in dep:
            infos.extend(dep[ShaderGroupInfo].list)
        files.append([f.path for f in dep[DefaultInfo].files.to_list()])

    out = ctx.actions.declare_file(ctx.attr.out)
    ctx.actions.write(
        output = out,
        content = json.encode_indent({
            "all_infos": infos,
            "all_files": files,
        }),
    )

    return [DefaultInfo(files = depset([out]))]

gather_metadata = rule(
    implementation = _shader_metadata_impl,
    attrs = {
        "out": attr.string(
            mandatory = True,
            doc = "JSON file name to write metadata output",
        ),
        "deps": attr.label_list(
            doc = """
	    List of shader targets to gather metadata from.
	    """,
            providers = [[ShaderInfo], [ShaderGroupInfo]],
        ),
    },
)
