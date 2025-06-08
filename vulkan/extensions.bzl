"""
Module extension for installing Vulkan SDKs.
"""

load("//vulkan:defs.bzl", "install_sdk")

def _vulkan_sdk_impl(ctx):
    for mod in ctx.modules:
        for tag in mod.tags.install:
            install_sdk(
                name = "vulkan_sdk_{}".format(tag.version),
                url = tag.url,
                sha256 = tag.sha256,
                version = tag.version,
            )

    return ctx.extension_metadata(
        reproducible = True,
    )

_install_tag = tag_class(
    attrs = {
        "version": attr.string(mandatory = True),
        "url": attr.string(),
        "sha256": attr.string(),
    },
)

vulkan_sdk = module_extension(
    implementation = _vulkan_sdk_impl,
    tag_classes = {
        "install": _install_tag,
    },
    os_dependent = True,
    arch_dependent = True,
)
