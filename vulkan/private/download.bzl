"""
Vulkan SDK downloader.
"""

load(":resolve.bzl", "normalize_version", "resolve_rt_url", "resolve_sdk_url")

def _install_linux(ctx, url, sha256, version):
    ctx.report_progress("Downloading and unpacking tarball...")
    ctx.download_and_extract(url, sha256 = sha256, output = "unpack", stripPrefix = version)

    ctx.symlink("unpack/x86_64/", "sdk")

    ctx.template("BUILD", ctx.attr.build_file, executable = False, substitutions = {
        "{os}": "linux",
        "{include_path}": "sdk/include",
        "{lib_vulkan}": "sdk/lib/libvulkan*.so*",
        "{lib_path}": str(ctx.path("sdk/lib")),
        "{bin_dxc}": "sdk/bin/dxc",
        "{bin_glslc}": "sdk/bin/glslc",
        "{bin_slangc}": "sdk/bin/slangc",
    })

def _install_macos(ctx, url, sha256, version):
    ctx.report_progress("Downloading intaller...")
    ctx.download_and_extract(
        url,
        sha256 = sha256,
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
        ctx.execute(
            [
                "./vulkansdk-macOS-{0}.app/Contents/MacOS/vulkansdk-macOS-{0}".format(version),
                "--root",
                ctx.path("unpack"),  # Warning: The installation path cannot be relative, please specify an absolute path.
                "--accept-licenses",
                "--default-answer",
                "--confirm-command",
                "install",
                # Optional components to install.
                # TODO: Make optional components configurable.
                "com.lunarg.vulkan.vma",
            ],
            quiet = False,
        )

        ctx.symlink("unpack/macOS/", "sdk")

    ctx.template("BUILD", ctx.attr.build_file, executable = False, substitutions = {
        "{os}": "macos",
        "{include_path}": "sdk/include",
        "{lib_vulkan}": "sdk/lib/libvulkan*.dylib",
        "{bin_dxc}": "sdk/bin/dxc",
        "{bin_glslc}": "sdk/bin/glslc",
        "{bin_slangc}": "sdk/bin/slangc",
    })

def _install_windows(ctx, version, sdk_url, sdk_sha256):
    ctx.report_progress("Downloading installer...")
    ctx.download(sdk_url, sha256 = sdk_sha256, output = "installer.exe")

    skip_rt = ctx.attr.windows_skip_runtime

    if not skip_rt:
        rt_url, rt_sha256 = resolve_rt_url(ctx, version)

        ctx.report_progress("Downloading runtime...")
        ctx.download_and_extract(
            rt_url,
            sha256 = rt_sha256,
            strip_prefix = "VulkanRT-{}-{}-Components\\x64".format("ARM64" if ctx.os.arch.startswith("arm") else "X64", version),
        )

    # See https://vulkan.lunarg.com/doc/sdk/latest/windows/getting_started.html
    ctx.report_progress("Installing components...")

    ctx.execute([
        "cmd.exe",
        "/c",
        "installer.exe",
        "--root",
        ctx.path("sdk"),
        "--verbose",
        "--accept-licenses",
        "--default-answer",
        "--confirm-command install",
        # For completely unattended installation and modifications,
        # the command prompt must be run as administrator.
        # There is an option to only copy the SDK files and not perform any operations to the registry
        # such as setting up new layers, creating shortcuts, and adjustments to the system path.
        # For the copy only option, append copy_only=1 to the end of the command line installer executable.
        "copy_only=1",
    ], quiet = False)

    ctx.template("BUILD", ctx.attr.build_file, executable = False, substitutions = {
        "{os}": "windows",
        "{include_path}": "sdk/Include",
        "{lib_vulkan}": "sdk/Lib/vulkan*.lib",
        "{bin_dxc}": "sdk/Bin/dxc.exe",
        "{bin_glslc}": "sdk/Bin/glslc.exe",
        "{bin_slangc}": "sdk/Bin/slangc.exe",
        "{vulkan_deps}": "" if skip_rt else "\":vulkan_dll\"",  # Skip runtime dependency if not installed.
    })

def _download_impl(ctx):
    sha256 = ctx.attr.sha256
    version = ctx.attr.version

    if not version:
        fail("Vulkan SDK version must be specified")

    version = normalize_version(version)

    # If no URL provided, try find one from the list of known releases.
    url = ctx.attr.url
    if not url:
        url, sha256 = resolve_sdk_url(ctx, version)

    os = ctx.os.name
    if os.startswith("linux"):
        _install_linux(ctx, url, sha256, version)
    elif os.startswith("mac"):
        _install_macos(ctx, url, sha256, version)
    elif os.startswith("windows"):
        _install_windows(ctx, version, url, sha256)
    else:
        fail("Unsupported OS: {}".format(os))

download_sdk = repository_rule(
    implementation = _download_impl,
    doc = """
    A rule to handle download and unpack of the SDK for each major platform (Windows, Linux, MacOS).

    These rely on command line installation described in "Getting started" docs on LunarG.
    - https://vulkan.lunarg.com/doc/view/1.3.283.0/mac/getting_started.html

    """,
    attrs = {
        "url": attr.string(
            mandatory = True,
            doc = """
	    URL to download the SDK package from.

	    Can be empty, in this case the download URL will be inherited from the provided version.
	    """,
        ),
        "sha256": attr.string(
            doc = "SDK package checksum",
        ),
        "version": attr.string(
            mandatory = True,
            doc = """
	    Vulkan SDK version to download and install.

	    This expects a version in the format of `1.4.313.0` or `1.4.313`.
	    When 3 components are provided, `.0` will be appended automatically to make it 4 components.
            """,
        ),
        "windows_skip_runtime": attr.bool(
            default = False,
            doc = """
            Do not download and install Vulkan runtime package (e.g. `vulkan-1.dll` dependency) on Windows.

            When `True`, the downloader with put `vulkan-1.dll` into the repository root directory.

            This is useful if there is a system-wide Vulkan runtime already installed, otherwise this
            might lead to link/runtime issues when building CC targets.
            """,
        ),
        "build_file": attr.label(default = Label("//vulkan/private:template.BUILD")),
    },
)
