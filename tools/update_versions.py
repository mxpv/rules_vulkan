#!/usr/bin/env python3

# Script to retrieve available SDK versions and file checksums
# based on https://vulkan.lunarg.com/content/view/latest-sdk-version-api

import json
import urllib.request
import urllib.error
import pprint
import time

VERSIONS_URL = "https://vulkan.lunarg.com/sdk/versions.json"
PLATFORMS = ["linux", "mac", "windows", "warm"]

# Fetch list of available Vulkan SDK versions
req = urllib.request.Request(VERSIONS_URL, headers={'User-Agent': 'Mozilla/5.0'})
with urllib.request.urlopen(req) as response:
    versions = json.loads(response.read().decode())

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
CHECKSUM_URL = "https://sdk.lunarg.com/sdk/sha/{version}/{platform}/{file}.json?Human=true"
DOWNLOAD_URL = "https://sdk.lunarg.com/sdk/download/{version}/{platform}/{file}"

# Make package name for download.
# This takes into account name changes that happened in the past.
def make_sdk_name(plat, ver):
    match plat:
        case "linux":
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

def make_rt_name(plat, ver):
    template = "VulkanRT-X64-{}-Components.zip" if plat == "windows" else "VulkanRT-ARM64-{}-Components.zip"
    if version_tuple(ver) <= (1, 4, 309, 0) and plat == "windows":
        template = "VulkanRT-{}-Components.zip"
    elif version_tuple(ver) <= (1, 3, 296, 0) and plat == "warm":
        template = "VulkanRT-{}-Components.zip"

    return template.format(ver)

def query(ver, plat, file, max_retries=3, initial_delay=1.0):
    print(f"Fetching checksum for {ver} on {plat} for file {file}...")

    url = CHECKSUM_URL.format(version=ver, platform=plat, file=file)
    print(f"  URL: {url}")

    # Query checksum URL with retry logic for rate limiting
    for attempt in range(max_retries):
        try:
            # Add a small delay before each request to avoid rate limiting
            if attempt > 0:
                delay = initial_delay * (2 ** attempt)
                print(f"  Retry {attempt + 1}/{max_retries} after {delay}s delay...")
                time.sleep(delay)

            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req) as resp:
                data = json.loads(resp.read().decode())
                break
        except urllib.error.HTTPError as e:
            if e.code == 404:
                # 404 means the package doesn't exist, no point retrying
                return None
            elif e.code == 403:
                # 403 might be rate limiting, retry with backoff
                if attempt < max_retries - 1:
                    print(f"  Got 403 (rate limit?), retrying...")
                    continue
                else:
                    print(f"  Got 403 after {max_retries} attempts, skipping...")
                    return None
            else:
                raise

    print(f"  Result: {data}")

    if isinstance(data, dict) and data.get("ok") is False and data.get("title") == "Not Found":
        return None

    # Extract URL and checksum
    url = DOWNLOAD_URL.format(version=ver, platform=plat, file=data["file"])
    sha = data["sha"]

    return url, sha

VERSIONS_JSON_PATH = "vulkan/private/versions.json"

# Load existing versions from JSON
with open(VERSIONS_JSON_PATH, "r") as f:
    output = json.load(f)
    print(f"Loaded {len(output)} existing versions from {VERSIONS_JSON_PATH}")

# Filter out metadata keys when comparing versions
current_versions = {k: v for k, v in output.items() if not k.startswith("_")}

# Determine which versions need to be fetched
new_versions = [v for v in versions if v not in current_versions]
removed_versions = [v for v in current_versions.keys() if v not in versions]

if removed_versions:
    print(f"\nRemoving {len(removed_versions)} versions no longer available:")
    for ver in removed_versions:
        print(f"  - {ver}")
        del current_versions[ver]

if new_versions:
    print(f"\nFetching {len(new_versions)} new versions:")
    for ver in new_versions:
        print(f"  - {ver}")
else:
    print("\nNo new versions to fetch")

# Only fetch checksums for new versions
for ver in new_versions:
    for plat in PLATFORMS:
        # Add a small delay between requests to avoid rate limiting
        time.sleep(0.5)

        result = query(ver, plat, make_sdk_name(plat, ver))

        # Skip if no such package
        if not result:
            continue

        url, sha = result

        current_versions.setdefault(ver, {})[plat] = {
            "url": url,
            "sha": sha,
        }

        # Check runtime packages on Windows.
        if plat == "windows" or plat == "warm":
            time.sleep(0.5)
            result = query(ver, plat, make_rt_name(plat, ver))
            if result:
                url, sha = result
                current_versions[ver][plat].update({
                    "runtime_url": url,
                    "runtime_sha": sha,
                })

# Sort by version descending and add metadata
ordered_output = {k: current_versions[k] for k in sorted(current_versions, reverse=True)}
ordered_output["_latest_version"] = latest_version

# Save to JSON file
with open(VERSIONS_JSON_PATH, "w") as f:
    json.dump(ordered_output, f, indent=2)
    print(f"\nSaved {len(current_versions)} versions to {VERSIONS_JSON_PATH}")
    print(f"Latest version: {latest_version}")

