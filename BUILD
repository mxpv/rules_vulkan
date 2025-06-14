load("@buildifier_prebuilt//:rules.bzl", "buildifier")

exports_files(["LICENSE"])

buildifier(name = "fmt")

buildifier(
    name = "lint",
    lint_mode = "warn",
    mode = "check",
)
