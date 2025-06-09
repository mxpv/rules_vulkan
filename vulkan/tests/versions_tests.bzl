load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//vulkan/private:versions.bzl", "VERSIONS")

def _version_test_impl(ctx):
    env = unittest.begin(ctx)

    allowed_platforms = ["linux", "mac", "windows", "warm"]

    asserts.true(env, len(VERSIONS) > 0)

    for ver, packages in VERSIONS.items():
        asserts.equals(env, ver.count("."), 3, "Version '%s' must contain exactly 3 dots" % ver)

        for plat, data in packages.items():
            asserts.true(env, plat in allowed_platforms, "Platform '%s' in version '%s' is not allowed" % (plat, ver))
            asserts.true(env, "url" in data, "Missing 'url' for version %s platform %s" % (ver, plat))
            asserts.true(env, "sha" in data, "Missing 'sha' for version %s platform %s" % (ver, plat))

    return unittest.end(env)

version_test = unittest.make(_version_test_impl)

def versions_test_suite(name):
    unittest.suite(name, version_test)
