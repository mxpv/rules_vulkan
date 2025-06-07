#!/usr/bin/env python3

# Script to retrieve available SDK versions and file checksums
# based on https://vulkan.lunarg.com/content/view/latest-sdk-version-api

import json
import requests
import pprint

VERSIONS_URL = "https://vulkan.lunarg.com/sdk/versions.json"
PLATFORMS = ["linux", "mac", "windows", "warm"]

# Fetch list of available Vulkan SDK versions
versions = requests.get(VERSIONS_URL).json()

print("Available versions:")
for version in versions:
    print(version)

# Find latest version.
version_tuple = lambda v: tuple(map(int, v.split(".")))
latest_version = max(versions, key=version_tuple)
print(f"Latest version: {latest_version}")

PLATFORMS = [
    "linux",
    "mac",
    "windows",
    "warm",
]

# Retrieve checksums.
# See "Get the SHA hash of the SDK file" in https://vulkan.lunarg.com/content/view/latest-sdk-version-api
CHECKSUM_URL = "https://sdk.lunarg.com/sdk/sha/{version}/{platform}/{file}.json"
DOWNLOAD_URL = "https://sdk.lunarg.com/sdk/download/{version}/{platform}/{file}"

def make_file_name(plat, ver):
    match plat:
        case "linux":
            if version_tuple(ver) <= (1, 3, 250, 1):
                return f"vulkansdk-linux-x86_64-{ver}.tar.gz"
            else:
                return "vulkan_sdk.tar.xz"
        case "mac":
            if version_tuple(ver) <= (1, 3, 290, 0):
                return f"vulkansdk-macos-{ver}.dmg"
            else:
                return "vulkan_sdk.zip"
        case "windows":
            if version_tuple(ver) <= (1, 4, 309, 0):
                return f"VulkanSDK-{ver}-Installer.exe"
            else:
                return f"vulkansdk-windows-X64-{ver}.exe"
        case "warm":
            if version_tuple(ver) <= (1, 4, 309, 0):
                return f"InstallVulkanARM64-{ver}.exe"
            else:
                return f"vulkansdk-windows-ARM64-{ver}.exe"
        case _:
            raise ValueError(f"Unknown platform: {plat}")

output = {}
for ver in versions:
    for plat in PLATFORMS:
        print(f"Fetching checksum for {ver} on {plat}...")

        url = CHECKSUM_URL.format(version=ver, platform=plat, file=make_file_name(plat, ver))
        print(f"  URL: {url}")

        # Query checksum URL.
        resp = requests.get(url)
        resp.raise_for_status

        data = resp.json()
        print(f"  Result: {data}")

        # Skip if not found.
        if isinstance(data, dict) and data.get("ok") is False and data.get("title") == "Not Found":
            continue

        output.setdefault(ver, {})[plat] = {
            "url": DOWNLOAD_URL.format(version=ver, platform=plat, file=data["file"]),
            "sha": data["sha"],
        }

# Sort top-level version keys descending, keep nested dicts as-is
ordered_output = {k: output[k] for k in sorted(output, reverse=True)}

with open("vulkan/private/versions.bzl", "w") as f:
    f.write("# GENERATED FILE. Do not edit.\n")
    f.write("# Use ./tools/update_versions.py to update the list of available SDK versions\n\n")

    f.write(f"LATEST_VERSION = \"{latest_version}\"\n\n")

    f.write("VERSIONS = ")
    json.dump(ordered_output, f, indent=4)

    f.write("\n\n")

