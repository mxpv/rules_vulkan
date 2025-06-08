"""
Module to resolve download URL and checksum from the provided SDK version.
"""

load(":versions.bzl", "VERSIONS")

def _normalize_os(os, arch):
    if os.startswith("linux"):
        return "linux"
    elif os.startswith("mac"):
        return "mac"
    elif os.startswith("win"):
        if arch.startswith("arm"):
            return "warm"
        else:
            return "windows"
    else:
        fail("Unsupported OS: {}".format(os))

def resolve_url(repository_ctx, version):
    """
    Finds download URL and checksum from version string.

    Args:
        repository_ctx: The repository context.
        version: 4 components Vulkan SDK version string (e.g., "1.4.313.0").

    Returns:
	A tuple containing the download URL and SHA256 checksum.
    """

    os = repository_ctx.os.name
    arch = repository_ctx.os.arch

    platforms = VERSIONS.get(version, None)
    if not platforms:
        fail("Unknown Vulkan SDK version: {}".format(version))

    target = _normalize_os(os, arch)
    info = platforms.get(target, None)
    if not info:
        fail("Unsupported target architecture {} for SDK {}", os, version)

    return info["url"], info["sha"]
