def _slang_shader_impl(ctx):
    slang = ctx.toolchains["//slang:toolchain_type"].slanginfo

    src = ctx.file.src
    entry = ctx.attr.entry
    target = ctx.attr.target
    stage = ctx.attr.stage
    lang = ctx.attr.lang

    out = ctx.actions.declare_file(ctx.label.name + "." + target)

    args = [
        "-profile",
        ctx.attr.profile,
        "-target",
        target,
        "-o",
        out.path,
    ]

    if stage:
        args += ["-stage", stage]

    if entry:
        args += ["-entry", entry]

    if lang:
        args += ["-lang", lang]

    for define in ctx.attr.defines:
        args += ["-D", define]

    for path in ctx.attr.includes:
        args += ["-I", path]

    args.append(src.path)

    ctx.actions.run(
        inputs = [src],
        outputs = [out],
        arguments = args,
        executable = slang.compiler,
        progress_message = "Compiling Slang shader %s" % src.path,
        mnemonic = "SlangCompile",
    )

    return [DefaultInfo(files = depset([out]))]

slang_shader = rule(
    implementation = _slang_shader_impl,
    doc = """
    Rule to compile Slang shaders.
    """,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "Input GLSL shader source to compile",
        ),
        "entry": attr.string(
            doc = "Entry point name",
        ),
        "includes": attr.string_list(
            doc = "Add a path to be used in resolved #include or #import operations",
        ),
        "defines": attr.string_list(
            doc = "Insert a preprocessor macro",
        ),
        "stage": attr.string(
            doc = "Stage of an entry point function",
        ),
        "profile": attr.string(
            mandatory = True,
            doc = "Shader profile for code generation",
        ),
        "target": attr.string(
            mandatory = True,
            doc = "Format in which code should be generated",
        ),
        "lang": attr.string(
            doc = "Set language for the shader",
        ),
        "extra_args": attr.string_list(
            doc = "Additional arguments to pass to the compiler",
        ),
    },
    toolchains = [":toolchain_type"],
)
