"""
Vulkan SDK downloader.
"""

load("@aspect_bazel_lib//lib:repo_utils.bzl", "repo_utils")
load(":resolve.bzl", "find_exact", "normalize_os", "normalize_version")

# Shared attributes between download_sdk rule and the module extension tag class.
DOWNLOAD_ATTRS = {
    "version": attr.string(
        mandatory = True,
        doc = """
            Vulkan SDK version to download and install.

            This expects a version in the format of `1.4.313.0` or `1.4.313`.
            When 3 components are provided, `.0` will be appended automatically to make it 4 components.
            """,
    ),
    "urls": attr.string_dict(
        doc = """
            Custom URLs and SHA256 checksums for the Vulkan SDK.

            This allows using a custom mirror for Vulkan SDKs instead of LunarG. When not specified, the SDK
            is downloaded from the default LunarG mirrors using the bundled `versions.json`.

            A separate download URL and SHA256 checksum is required for each platform. LunarG currently uses
            the following platform keys:
            - `windows` - Windows x86-64
            - `warm` - Windows ARM64
            - `mac` - macOS
            - `linux` - Linux

            Each entry must provide `url` and `sha` fields. On Windows platforms, `runtime_url` and
            `runtime_sha` can be used to provide URLs for the Vulkan runtime package.

            Example:
            ```bazel
            custom_urls = {
                "linux": {
                    "url": "https://sdk.lunarg.com/sdk/download/1.4.313.0/linux/vulkansdk-linux-x86_64-1.4.313.0.tar.xz",
                    "sha": "4e957b66ade85eeaee95932aa7e3b45aea64db373c58a5eaefc8228cc71445c2",
                },
                "mac": {
                    "url": "https://sdk.lunarg.com/sdk/download/1.4.313.0/mac/vulkansdk-macos-1.4.313.0.zip",
                    "sha": "782a966ef4d5d68acaa933ff45215df2e34f286df8f6077270202f218110dc20",
                },
                "windows": {
                    "url": "https://sdk.lunarg.com/sdk/download/1.4.313.0/windows/vulkansdk-windows-X64-1.4.313.0.exe",
                    "sha": "b643ca8ab4aea5c47b9c4e021a0b33b3a13871bf1d8131e162a9e48c257c4694",
                    "runtime_url": "https://sdk.lunarg.com/sdk/download/1.4.313.0/windows/VulkanRT-X64-1.4.313.0-Components.zip",
                    "runtime_sha": "e8d37913185142270a2bc1b3e1f8f498a4edf47405fddda666f2f38b30ca944b",
                },
                "warm": {
                    "url": "https://sdk.lunarg.com/sdk/download/1.4.313.0/warm/vulkansdk-windows-ARM64-1.4.313.0.exe",
                    "sha": "b19a8683df982d302fec07c110962153f02a2e5cf1e5118ff72d8532aa5fc567",
                    "runtime_url": "https://sdk.lunarg.com/sdk/download/1.4.313.0/warm/VulkanRT-ARM64-1.4.313.0-Components.zip",
                    "runtime_sha": "6335a8d6b7ab85861025c2546f5f52384ff18a6d9346d350c2a0bf3b7524829a",
                },
            }
            ```
            """,
    ),
    "windows_components": attr.string_list(
        default = [],
        doc = """
            Optional Vulkan SDK components to install on Windows.

            These are passed to the installer between `--confirm-command install` and `copy_only=1`.

            Known components: `com.lunarg.vulkan.sdl2`, `com.lunarg.vulkan.glm`, `com.lunarg.vulkan.volk`,
            `com.lunarg.vulkan.vma`, `com.lunarg.vulkan.debug`.
            """,
    ),
    "macos_components": attr.string_list(
        default = [],
        doc = """
            Optional Vulkan SDK components to install on macOS.

            These are passed to the installer after `--confirm-command install`.

            Known components: `com.lunarg.vulkan.usr`, `com.lunarg.vulkan.sdl2`, `com.lunarg.vulkan.glm`,
            `com.lunarg.vulkan.volk`, `com.lunarg.vulkan.vma`, `com.lunarg.vulkan.ios`,
            `com.lunarg.vulkan.kosmic`.
            """,
    ),
    "windows_skip_runtime": attr.bool(
        default = False,
        doc = """
            Do not download and install Vulkan runtime package (e.g. `vulkan-1.dll` dependency) on Windows.

            When `True`, the downloader will not put `vulkan-1.dll` into the repository root directory.

            This is useful if there is a system-wide Vulkan runtime already installed, otherwise this
            might lead to link/runtime issues when building CC targets.
            """,
    ),
}

def _install_linux(ctx, urls, version, attrs):
    ctx.report_progress("Downloading and unpacking tarball...")
    ctx.download_and_extract(
        urls["url"],
        sha256 = urls["sha"],
        output = "unpack",
        stripPrefix = version,
    )

    ctx.symlink("unpack/x86_64/", "sdk")

    attrs.update({
        "{os}": "linux",
        "{sdk_root}": str(ctx.path("sdk")),
    })

def _install_macos(ctx, urls, version, attrs):
    ctx.report_progress("Downloading installer...")
    ctx.download_and_extract(
        urls["url"],
        sha256 = urls["sha"],
        output = "installer",
    )

    # Install Vulkan components from terminal
    # See https://vulkan.lunarg.com/doc/view/1.3.283.0/mac/getting_started.html
    #
    # The installer downloads components from internet, which Bazel can't really track.
    # And hence this gets invoked every time any dependent targets are built.
    #
    # To mitigate this, this will check if "sdk" symlink already exists, and if so, the
    # download will be skipped.
    #
    # This is not ideal and might need to be revisited in future, but it works.
    if not ctx.path("sdk").exists:
        ctx.report_progress("Running installer...")
        cmd = [
            "./installer/vulkansdk-macOS-{0}.app/Contents/MacOS/vulkansdk-macOS-{0}".format(version),
            "--root",
            ctx.path("unpack"),  # Warning: The installation path cannot be relative, please specify an absolute path.
            "--accept-licenses",
            "--default-answer",
            "--confirm-command",
            "install",
        ] + ctx.attr.macos_components
        ctx.execute(cmd, quiet = False)

        ctx.symlink("unpack/macOS/", "sdk")

    attrs.update({
        "{os}": "macos",
        "{sdk_root}": str(ctx.path("sdk")),
    })

def _install_windows(ctx, urls, version, attrs):
    ctx.report_progress("Downloading installer...")
    ctx.download(
        urls["url"],
        sha256 = urls["sha"],
        output = "installer.exe",
    )

    skip_rt = ctx.attr.windows_skip_runtime

    if not skip_rt:
        is_arm = ctx.os.arch.startswith("arm")

        ctx.report_progress("Downloading runtime...")
        ctx.download_and_extract(
            urls["runtime_url"],
            sha256 = urls["runtime_sha"],
            strip_prefix = "VulkanRT-{}-{}-Components\\{}".format(
                "ARM64" if is_arm else "X64",
                version,
                "" if is_arm else "x64",  # on x64 there is an additional x64 subdirectory
            ),
        )

    # The Qt IFW installer registers in "Installed apps" even with copy_only=1.
    # Running the install command multiple times creates duplicate entries in
    # "Installed apps" all pointing to the same directory. Manually removing one
    # entry causes the remaining entries to become broken. To prevent this, delete
    # stale registry entries pointing to the current install directory before
    # rerunning the installer.
    sdk_path = str(ctx.path("sdk")).replace("/", "\\")
    unreg = ctx.execute([
        "reg",
        "query",
        "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall",
        "/s",
        "/f",
        sdk_path,
        "/d",
    ])
    if unreg.return_code == 0:
        ctx.report_progress("Removing stale registry entries...")
        for line in unreg.stdout.split("\n"):
            line = line.strip()
            if line.startswith("HKEY_"):
                ctx.execute(["reg", "delete", line, "/f"])

    # See https://vulkan.lunarg.com/doc/sdk/latest/windows/getting_started.html
    ctx.report_progress("Installing components...")

    cmd = [
        "cmd.exe",
        "/c",
        "installer.exe",
        "--root",
        ctx.path("sdk"),
        "--verbose",
        "--accept-licenses",
        "--default-answer",
        "--confirm-command install",
    ] + ctx.attr.windows_components + [
        # For completely unattended installation and modifications,
        # the command prompt must be run as administrator.
        # There is an option to only copy the SDK files and not perform any operations to the registry
        # such as setting up new layers, creating shortcuts, and adjustments to the system path.
        # For the copy only option, append copy_only=1 to the end of the command line installer executable.
        "copy_only=1",
    ]
    ctx.execute(cmd, quiet = False)

    attrs.update({
        "{os}": "windows",
        "{sdk_root}": str(ctx.path("sdk")),
    })

def _download_impl(ctx):
    version = ctx.attr.version
    if not version:
        fail("Vulkan SDK version must be specified")
    version = normalize_version(version)

    # Fetch the list of download URLs for the provided SDK version
    urls = ctx.attr.urls
    if not urls:
        # Fetch URLs for known SDK versions
        urls = find_exact(ctx, version)

    # Fetch URLs for the current platform
    platform = normalize_os(ctx)
    urls = urls.get(platform, None)
    if not urls:
        fail("Download URLs not found for platform {} and SDK {}".format(platform, version))

    attrs = {
        "{os}": "",
        "{sdk_root}": "",
    }

    if repo_utils.is_linux(ctx):
        _install_linux(ctx, urls, version, attrs)
    elif repo_utils.is_darwin(ctx):
        _install_macos(ctx, urls, version, attrs)
    elif repo_utils.is_windows(ctx):
        _install_windows(ctx, urls, version, attrs)
    else:
        fail("Unsupported OS: {}".format(platform))

    ctx.template("BUILD", ctx.attr.build_file, executable = False, substitutions = attrs)

    # Generate paths.bzl with SDK paths for consumers.
    if repo_utils.is_windows(ctx):
        layer_path = attrs["{sdk_root}"] + "/Bin"
    else:
        layer_path = attrs["{sdk_root}"] + "/share/vulkan/explicit_layer.d"

    ctx.file("paths.bzl", content = "\n".join([
        '"""Auto-generated SDK paths."""',
        "",
        'VULKAN_SDK = "{}"'.format(attrs["{sdk_root}"]),
        'VALIDATION_LAYER_PATH = "{}"'.format(layer_path),
        "",
    ]))

download_sdk = repository_rule(
    implementation = _download_impl,
    doc = """
    A rule to handle download and unpack of the SDK for each major platform (Windows, Linux, MacOS).

    These rely on command line installation described in "Getting started" docs on LunarG.
    - https://vulkan.lunarg.com/doc/view/1.3.283.0/mac/getting_started.html

    """,
    attrs = dict(DOWNLOAD_ATTRS, **{
        "build_file": attr.label(default = Label("//vulkan/private:template.BUILD")),
    }),
)
