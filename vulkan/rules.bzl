"""
Common Vulkan rules.
"""

load("@bazel_skylib//lib:paths.bzl", "paths")
load("@rules_pkg//pkg:providers.bzl", "PackageFilesInfo")
load("//vulkan:providers.bzl", "ShaderGroupInfo", "ShaderInfo")

def _shader_group_impl(ctx):
    all_files = []
    all_infos = []
    src_map = {}

    prefix = ctx.attr.pkg_prefix or ""

    for dep in ctx.attr.deps:
        if ShaderInfo in dep:
            all_infos.append(dep[ShaderInfo])
        elif ShaderGroupInfo in dep:
            all_infos.extend(dep[ShaderGroupInfo].list)

        # Recursively merge dest_src_map if dep already provides PackageFilesInfo
        if PackageFilesInfo in dep:
            for k, v in dep[PackageFilesInfo].dest_src_map.items():
                src_map[paths.join(prefix, k)] = v
        else:
            for f in dep[DefaultInfo].files.to_list():
                src_map[paths.join(prefix, f.basename)] = f

    all_files.extend(src_map.values())

    return [
        DefaultInfo(files = depset(all_files)),
        ShaderGroupInfo(list = all_infos),
        PackageFilesInfo(dest_src_map = src_map),
    ]

shader_group = rule(
    implementation = _shader_group_impl,
    doc = """
    `shadergroup` is a rule to group multiple shaders together.

    This is a kin of `filegroup`, which forwards providers.

    Roughly the motivation for this is described in this [issue](https://github.com/bazelbuild/bazel/issues/8904).

    There are a few use cases where this can be useful:
    - Group a few related shaders together (e.g. vertex + pixel shader).
    - Group lots of shaders to build a library or a database. Refer to `e2e/smoke` example how to approach this.
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
        "pkg_prefix": attr.string(
            doc = "If using with `rules_pkg`, sub-directory in the destination archive",
        ),
    },
    provides = [ShaderGroupInfo, PackageFilesInfo],
)
