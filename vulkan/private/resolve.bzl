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

def resolve_url(version, os, arch):
    platforms = VERSIONS.get(version, None)
    if not platforms:
        fail("Unknown Vulkan SDK version: {}".format(version))

    target = _normalize_os(os, arch)
    info = platforms.get(target, None)
    if not info:
        fail("Unsupported target architecture {} for SDK {}", os, version)

    return info["url"], info["sha"]

