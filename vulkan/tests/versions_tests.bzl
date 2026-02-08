"""
Test suite for version utility functions.
"""

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//vulkan/private:resolve.bzl", "normalize_version")

def _normalize_version_test_impl(ctx):
    env = unittest.begin(ctx)

    # 3 components: should append .0
    asserts.equals(
        env,
        normalize_version("1.4.313"),
        "1.4.313.0",
        "Should append '.0' for 3-component version",
    )

    # 4 components: should stay as-is
    asserts.equals(
        env,
        normalize_version("1.4.313.0"),
        "1.4.313.0",
        "Should return as-is for 4-component version",
    )

    return unittest.end(env)

normalize_version_test = unittest.make(_normalize_version_test_impl)

def versions_test_suite(name):
    unittest.suite(name, normalize_version_test)
