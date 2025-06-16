"""
Vulkan providers.
"""

ShaderInfo = provider(
    doc = """
    Shader metadata returned by the shader targets during compilation.

    This is useful for building all kind of shader databases.
    """,
    fields = [
        "entry",  # Entry point of the shader
        "stage",  # Shader stage (e.g., vertex, fragment)
        "target",  # Shader target (this is compiler specific)
        "defines",  # Preprocessor definitions
        "includes",  # Include paths for shader compilation
    ],
)
