"""
Vulkan providers.
"""

ShaderInfo = provider(
    doc = """
    Shader metadata returned by the shader targets during compilation.

    This is useful for building all kind of shader databases.
    """,
    fields = {
        "label": "Target's label this metadata belongs to",
        "outs": "List of compiler outputs",
        "entry": "Shader entry point function name",
        "stage": "Shader stage",
        "defines": "List of shader defines used during compilation",
        "target": "Compilation target (note: this depends on compiler used)",
    },
)

ShaderGroupInfo = provider(
    doc = """
    A collection of shader infos.
    """,
    fields = {
        "list": "List of ShaderInfo structures",
    },
)
