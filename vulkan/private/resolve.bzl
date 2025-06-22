"""
Module to resolve download URL and checksum from the provided SDK version.
"""

load(":versions.bzl", "VERSIONS")

def normalize_os(os, arch):
    """
    Convert Bazel OS string to LunarG platform name.

    Args:
        os: OS name fetched from the repository context.
        arch: Arch name.
    Returns:
        Platform name
    """
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

def find_exact(version):
    """
    Find exact record in the VERSIONS table from the provided version and OS/arch retrieved from the `ctx`

    Args:
        version: exact version string to fetch info.

    Returns:
        A dictionary with URLs for each supported platform.
	Note: LunarG may release patch releases for certain platforms, so some platform entries might be missing.
    """
    platforms = VERSIONS.get(version, None)
    if not platforms:
        fail("Unsupported Vulkan SDK version: {}".format(version))

    return platforms
