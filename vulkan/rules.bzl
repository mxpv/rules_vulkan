"""
Common Vulkan rules.
"""

load("//vulkan:providers.bzl", "ShaderGroupInfo", "ShaderInfo")

def _shader_group_impl(ctx):
    all_files = []
    all_infos = []

    for dep in ctx.attr.deps:
        all_files.extend(dep[DefaultInfo].files.to_list())

        if ShaderInfo in dep:
            all_infos.append(dep[ShaderInfo])
        elif ShaderGroupInfo in dep:
            all_infos.extend(dep[ShaderGroupInfo].list)

    return [
        DefaultInfo(files = depset(all_files)),
        ShaderGroupInfo(list = all_infos),
    ]

shader_group = rule(
    implementation = _shader_group_impl,
    doc = """
    `shadergroup` is a rule to group multiple shaders together.

    This is a kin of `filegroup`, which forwards providers.

    Roughly the motivation for this is described in this [issue](https://github.com/bazelbuild/bazel/issues/8904).
    """,
    attrs = {
        "deps": attr.label_list(
            doc = """
	    List of shader targets to group together.

	    This can depend either on a shader target directly (HLSL, GLSL, or Slang) or any other `shader_group`.
	    """,
            allow_files = True,
            providers = [[ShaderInfo], [ShaderGroupInfo]],
        ),
    },
    provides = [ShaderGroupInfo],
)
