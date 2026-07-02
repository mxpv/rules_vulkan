"""
Module extension to manage Vulkan SDKs.
"""

load("//vulkan:defs.bzl", "INSTALL_ATTRS", "install_sdk")

def _vulkan_sdk_impl(ctx):
    generated = {}
    for mod in ctx.modules:
        for tag in mod.tags.toolchain:
            name = tag.name if tag.name else "vulkan_sdk_{}".format(tag.version)
            kwargs = {k: getattr(tag, k) for k in INSTALL_ATTRS}
            if name in generated:
                if generated[name] != kwargs:
                    fail(
                        ("Conflicting vulkan_sdk.toolchain tags resolve to the " +
                         "same repository '{}' but request different attributes:\n" +
                         "  {}\n" +
                         "vs\n" +
                         "  {}\n" +
                         "Give one of the tags a distinct `name` to install both.").format(
                            name,
                            generated[name],
                            kwargs,
                        ),
                    )
                continue
            generated[name] = kwargs
            install_sdk(name = name, **kwargs)

    return ctx.extension_metadata(
        reproducible = True,
    )

_toolchain_tag = tag_class(
    attrs = dict(INSTALL_ATTRS, **{
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
