load("//vulkan:defs.bzl", "install_sdk")

def _vulkan_sdk_impl(ctx):
    for mod in ctx.modules:
        for tag in mod.tags.install:
            version = tag.version
            url = "https://sdk.lunarg.com/sdk/download/{0}/mac/vulkansdk-macos-{0}.zip".format(version)

            install_sdk(
                name = "vulkan_sdk_{}".format(version),
                url = url,
                sha256 = "69cdbdd8dbf7fe93b40f1b653b7b3e458bf3cbe368582b56476f6a780c662aa3",
                version = version,
            )

    return ctx.extension_metadata(
        reproducible = True,
    )


_install_tag = tag_class(
    attrs = {
        "version": attr.string(),
    }
)

vulkan_sdk = module_extension(
    implementation = _vulkan_sdk_impl,
    tag_classes = {
        "install": _install_tag,
    },
    os_dependent = True,
    arch_dependent = True,
)

