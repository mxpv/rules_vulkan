"""
Module extension to manage Vulkan SDKs.
"""

load("//vulkan:defs.bzl", "DOWNLOAD_ATTRS", "download_sdk")

def _vulkan_sdk_impl(ctx):
    for mod in ctx.modules:
        for tag in mod.tags.toolchain:
            name = tag.name
            kwargs = {k: getattr(tag, k) for k in DOWNLOAD_ATTRS}
            download_sdk(
                name = name if name else "vulkan_sdk_{}".format(tag.version),
                **kwargs
            )

    return ctx.extension_metadata(
        reproducible = True,
    )

_toolchain_tag = tag_class(
    attrs = dict(DOWNLOAD_ATTRS, **{
        "name": attr.string(
            doc = """
            Optional repository name alias.

            If not specified, will use "vulkan_sdk_{version}".
            """,
        ),
    }),
)

vulkan_sdk = module_extension(
    implementation = _vulkan_sdk_impl,
    doc = """
    Module extension to manage Vulkan SDKs.
    """,
    tag_classes = {
        "toolchain": _toolchain_tag,
    },
    os_dependent = True,
    arch_dependent = True,
)
