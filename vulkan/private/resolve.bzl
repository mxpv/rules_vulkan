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

def normalize_version(version):
    """
    Normalize SDK version string to ensure it has 4 components.

    Args:
        version: Version string in the format 'X.Y.Z' or 'X.Y.Z.W'
    Returns:
        Version as 'X.Y.Z.0' if only three components, else returns as-is."""
    parts = version.split(".")
    if len(parts) == 3:
        return version + ".0"

    return version

def _find_exact(ctx, version):
    """
    Find exact record in the VERSIONS table from the provided version and OS/arch retrieved from the `ctx`

    Args:
        ctx: repository context.
        version: exact version string to fetch info.

    Returns:
    `None` if no record found, otherwise a struct with 'url' and 'sha' fields.
    """
    platforms = VERSIONS.get(version, None)
    if not platforms:
        return None

    os = ctx.os.name
    arch = ctx.os.arch

    target = _normalize_os(os, arch)
    info = platforms.get(target, None)
    if not info:
        return None

    return info

def resolve_url(ctx, version):
    """
    Finds download Vulakn SDK URL and checksum from version string.

    Args:
        ctx: The repository context.
        version: 4 components Vulkan SDK version string (e.g., "1.4.313.1").

    Returns:
	A tuple containing the download URL and SHA256 checksum.
    """

    info = _find_exact(ctx, version)
    if not info:
        fail("Unknown Vulkan SDK version {} on {} {}", version, ctx.os.name, ctx.os.arch)

    return info["url"], info["sha"]
