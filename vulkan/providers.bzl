"""
Vulkan providers.
"""

ShaderInfo = provider(
    doc = """
    Shader metadata returned by the shader targets during compilation.

    This is useful for building all kind of shader databases.
    """,
    fields = {
        "entry": "Shader entry point function name",
        "stage": "Shader stage",
        "defines": "List of shader defines used during compilation",
        "target": "Compilation target (note: this depends on compiler used)",
    },
)
