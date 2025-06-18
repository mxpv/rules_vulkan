<!-- Generated with Stardoc: http://skydoc.bazel.build -->

All project entries to generate documentation for.

<a id="glsl_shader"></a>

## glsl_shader

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "glsl_shader")

glsl_shader(<a href="#glsl_shader-name">name</a>, <a href="#glsl_shader-src">src</a>, <a href="#glsl_shader-hdrs">hdrs</a>, <a href="#glsl_shader-defines">defines</a>, <a href="#glsl_shader-includes">includes</a>, <a href="#glsl_shader-opts">opts</a>, <a href="#glsl_shader-stage">stage</a>, <a href="#glsl_shader-std">std</a>, <a href="#glsl_shader-target_env">target_env</a>, <a href="#glsl_shader-target_spv">target_spv</a>)
</pre>

Rule to compile GLSL shader.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="glsl_shader-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="glsl_shader-src"></a>src |  Input GLSL shader source to compile   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="glsl_shader-hdrs"></a>hdrs |  List of header files dependencies to be included in the shader compilation   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="glsl_shader-defines"></a>defines |  List of macro defines   | List of strings | optional |  `[]`  |
| <a id="glsl_shader-includes"></a>includes |  Add directory to include search path to CLI   | List of strings | optional |  `[]`  |
| <a id="glsl_shader-opts"></a>opts |  Additional arguments to pass to the compiler   | List of strings | optional |  `[]`  |
| <a id="glsl_shader-stage"></a>stage |  Shader stage (vertex, vert, fragment, frag, etc)   | String | required |  |
| <a id="glsl_shader-std"></a>std |  Version and profile for GLSL input files.<br><br>Possible values are concatenations of version and profile, e.g. `310es`, `450core`, etc.   | String | optional |  `""`  |
| <a id="glsl_shader-target_env"></a>target_env |  Set the target client environment, and the semantics of warnings and errors.<br><br>An optional suffix can specify the client version.   | String | optional |  `""`  |
| <a id="glsl_shader-target_spv"></a>target_spv |  Set the SPIR-V version to be used for the generated SPIR-V module.<br><br>The default is the highest version of SPIR-V required to be supported for the target environment. For example, default for `vulkan1.0` is `spv1.0`.   | String | optional |  `""`  |


<a id="glsl_toolchain"></a>

## glsl_toolchain

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "glsl_toolchain")

glsl_toolchain(<a href="#glsl_toolchain-name">name</a>, <a href="#glsl_toolchain-compiler">compiler</a>)
</pre>

GLSL Toolchain

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="glsl_toolchain-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="glsl_toolchain-compiler"></a>compiler |  Path to compiler executable   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


<a id="hlsl_shader"></a>

## hlsl_shader

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "hlsl_shader")

hlsl_shader(<a href="#hlsl_shader-name">name</a>, <a href="#hlsl_shader-src">src</a>, <a href="#hlsl_shader-hdrs">hdrs</a>, <a href="#hlsl_shader-asm">asm</a>, <a href="#hlsl_shader-def_root_sig">def_root_sig</a>, <a href="#hlsl_shader-defines">defines</a>, <a href="#hlsl_shader-entry">entry</a>, <a href="#hlsl_shader-hash">hash</a>, <a href="#hlsl_shader-hlsl">hlsl</a>, <a href="#hlsl_shader-includes">includes</a>, <a href="#hlsl_shader-opts">opts</a>, <a href="#hlsl_shader-reflect">reflect</a>,
            <a href="#hlsl_shader-spirv">spirv</a>, <a href="#hlsl_shader-target">target</a>)
</pre>

Rule to compile HLSL shaders using DirectXShaderCompiler.

The target will output <name>.cso file with bytecode output.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="hlsl_shader-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="hlsl_shader-src"></a>src |  Input HLSL shader source file   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="hlsl_shader-hdrs"></a>hdrs |  List of header files dependencies to be included in the shader compilation   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="hlsl_shader-asm"></a>asm |  Output assembly code listing file (-Fc <file>). This will produce <name>.asm file   | Boolean | optional |  `False`  |
| <a id="hlsl_shader-def_root_sig"></a>def_root_sig |  Read root signature from a #define (-rootsig-define <value>)   | String | optional |  `""`  |
| <a id="hlsl_shader-defines"></a>defines |  List of macro defines   | List of strings | optional |  `[]`  |
| <a id="hlsl_shader-entry"></a>entry |  Entry point name   | String | optional |  `"main"`  |
| <a id="hlsl_shader-hash"></a>hash |  Output shader hash to the given file (-Fsh <file>). This will produce <name>.hash file   | Boolean | optional |  `False`  |
| <a id="hlsl_shader-hlsl"></a>hlsl |  HLSL version to use (2016, 2017, 2018, 2021)   | String | optional |  `""`  |
| <a id="hlsl_shader-includes"></a>includes |  List of directories to be added to the CLI to search for include files   | List of strings | optional |  `[]`  |
| <a id="hlsl_shader-opts"></a>opts |  Additional arguments to pass to the DXC compiler   | List of strings | optional |  `[]`  |
| <a id="hlsl_shader-reflect"></a>reflect |  Output reflection to the given file (-Fre <file>). This will produce <name>.reflect file   | Boolean | optional |  `False`  |
| <a id="hlsl_shader-spirv"></a>spirv |  Generate SPIR-V code   | Boolean | optional |  `False`  |
| <a id="hlsl_shader-target"></a>target |  Target profile (e.g., cs_6_0, ps_6_0, etc.)   | String | required |  |


<a id="hlsl_toolchain"></a>

## hlsl_toolchain

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "hlsl_toolchain")

hlsl_toolchain(<a href="#hlsl_toolchain-name">name</a>, <a href="#hlsl_toolchain-compiler">compiler</a>, <a href="#hlsl_toolchain-env">env</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="hlsl_toolchain-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="hlsl_toolchain-compiler"></a>compiler |  Path to the HLSL compiler executable (e.g., dxc)   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="hlsl_toolchain-env"></a>env |  Environment variables to set for the HLSL compiler.<br><br>This can be used to set additional paths or configurations needed by the HLSL compiler.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |


<a id="shader_group"></a>

## shader_group

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "shader_group")

shader_group(<a href="#shader_group-name">name</a>, <a href="#shader_group-deps">deps</a>, <a href="#shader_group-pkg_prefix">pkg_prefix</a>)
</pre>

`shadergroup` is a rule to group multiple shaders together.

This is a kin of `filegroup`, which forwards providers.

Roughly the motivation for this is described in this [issue](https://github.com/bazelbuild/bazel/issues/8904).

There are a few use cases where this can be useful:
- Group a few related shaders together (e.g. vertex + pixel shader).
- Group lots of shaders to build a library or a database. Refer to `e2e/smoke` example how to approach this.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="shader_group-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="shader_group-deps"></a>deps |  List of shader targets to group together.<br><br>This can depend either on a shader target directly (HLSL, GLSL, or Slang) or any other `shader_group`.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="shader_group-pkg_prefix"></a>pkg_prefix |  If using with `rules_pkg`, sub-directory in the destination archive   | String | optional |  `""`  |


<a id="slang_shader"></a>

## slang_shader

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "slang_shader")

slang_shader(<a href="#slang_shader-name">name</a>, <a href="#slang_shader-src">src</a>, <a href="#slang_shader-hdrs">hdrs</a>, <a href="#slang_shader-defines">defines</a>, <a href="#slang_shader-depfile">depfile</a>, <a href="#slang_shader-entry">entry</a>, <a href="#slang_shader-includes">includes</a>, <a href="#slang_shader-lang">lang</a>, <a href="#slang_shader-opts">opts</a>, <a href="#slang_shader-profile">profile</a>, <a href="#slang_shader-reflect">reflect</a>,
             <a href="#slang_shader-stage">stage</a>, <a href="#slang_shader-target">target</a>)
</pre>

Rule to compile Slang shaders.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="slang_shader-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="slang_shader-src"></a>src |  Input shader source to compile   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="slang_shader-hdrs"></a>hdrs |  List of header files dependencies to be included in the shader compilation   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="slang_shader-defines"></a>defines |  Insert a preprocessor macro   | List of strings | optional |  `[]`  |
| <a id="slang_shader-depfile"></a>depfile |  Save the source file dependency list in a file (-depfile <name>.dep)   | Boolean | optional |  `False`  |
| <a id="slang_shader-entry"></a>entry |  Entry point name   | String | optional |  `""`  |
| <a id="slang_shader-includes"></a>includes |  Add a path to CLI to be used to search #include or #import operations   | List of strings | optional |  `[]`  |
| <a id="slang_shader-lang"></a>lang |  Set source language for the shader (slang, hlsl, glsl, cpp, etc)   | String | optional |  `""`  |
| <a id="slang_shader-opts"></a>opts |  Additional arguments to pass to the compiler   | List of strings | optional |  `[]`  |
| <a id="slang_shader-profile"></a>profile |  Shader profile for code generation (sm_6_6, vs_6_6, glsl_460, etc)   | String | required |  |
| <a id="slang_shader-reflect"></a>reflect |  Emit reflection data in JSON format to a file <name>.json   | Boolean | optional |  `False`  |
| <a id="slang_shader-stage"></a>stage |  Stage of an entry point function (vertex, pixel, compute, etc)   | String | optional |  `""`  |
| <a id="slang_shader-target"></a>target |  Format in which code should be generated (hlsl, dxil, dxil-asm, glsl, spirv, metal, metallib, etc)   | String | required |  |


<a id="slang_toolchain"></a>

## slang_toolchain

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "slang_toolchain")

slang_toolchain(<a href="#slang_toolchain-name">name</a>, <a href="#slang_toolchain-compiler">compiler</a>, <a href="#slang_toolchain-env">env</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="slang_toolchain-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="slang_toolchain-compiler"></a>compiler |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="slang_toolchain-env"></a>env |  Environment variables to set for the Slang compiler.<br><br>This can be used to set additional paths or configurations needed by the Slang compiler.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |


<a id="GlslCompilerInfo"></a>

## GlslCompilerInfo

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "GlslCompilerInfo")

GlslCompilerInfo(<a href="#GlslCompilerInfo-compiler">compiler</a>)
</pre>

Information about GLSL compiler

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="GlslCompilerInfo-compiler"></a>compiler |  -    |


<a id="HlslCompilerInfo"></a>

## HlslCompilerInfo

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "HlslCompilerInfo")

HlslCompilerInfo(<a href="#HlslCompilerInfo-compiler">compiler</a>, <a href="#HlslCompilerInfo-env">env</a>)
</pre>

Information about HLSL compiler

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="HlslCompilerInfo-compiler"></a>compiler |  -    |
| <a id="HlslCompilerInfo-env"></a>env |  -    |


<a id="ShaderInfo"></a>

## ShaderInfo

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "ShaderInfo")

ShaderInfo(<a href="#ShaderInfo-label">label</a>, <a href="#ShaderInfo-outs">outs</a>, <a href="#ShaderInfo-entry">entry</a>, <a href="#ShaderInfo-stage">stage</a>, <a href="#ShaderInfo-defines">defines</a>, <a href="#ShaderInfo-target">target</a>)
</pre>

Shader metadata returned by the shader targets during compilation.

This is useful for building all kind of shader databases.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="ShaderInfo-label"></a>label |  Target's label this metadata belongs to    |
| <a id="ShaderInfo-outs"></a>outs |  List of compiler outputs    |
| <a id="ShaderInfo-entry"></a>entry |  Shader entry point function name    |
| <a id="ShaderInfo-stage"></a>stage |  Shader stage    |
| <a id="ShaderInfo-defines"></a>defines |  List of shader defines used during compilation    |
| <a id="ShaderInfo-target"></a>target |  Compilation target (note: this depends on compiler used)    |


<a id="SlangCompilerInfo"></a>

## SlangCompilerInfo

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "SlangCompilerInfo")

SlangCompilerInfo(<a href="#SlangCompilerInfo-compiler">compiler</a>, <a href="#SlangCompilerInfo-env">env</a>)
</pre>

Information about Slang compiler

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="SlangCompilerInfo-compiler"></a>compiler |  -    |
| <a id="SlangCompilerInfo-env"></a>env |  -    |


<a id="download_sdk"></a>

## download_sdk

<pre>
load("@rules_vulkan//docs:docs_hub.bzl", "download_sdk")

download_sdk(<a href="#download_sdk-name">name</a>, <a href="#download_sdk-build_file">build_file</a>, <a href="#download_sdk-repo_mapping">repo_mapping</a>, <a href="#download_sdk-sha256">sha256</a>, <a href="#download_sdk-url">url</a>, <a href="#download_sdk-version">version</a>, <a href="#download_sdk-windows_skip_runtime">windows_skip_runtime</a>)
</pre>

A rule to handle download and unpack of the SDK for each major platform (Windows, Linux, MacOS).

These rely on command line installation described in "Getting started" docs on LunarG.
- https://vulkan.lunarg.com/doc/view/1.3.283.0/mac/getting_started.html

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="download_sdk-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="download_sdk-build_file"></a>build_file |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `"@rules_vulkan//vulkan/private:template.BUILD"`  |
| <a id="download_sdk-repo_mapping"></a>repo_mapping |  In `WORKSPACE` context only: a dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.<br><br>For example, an entry `"@foo": "@bar"` declares that, for any time this repository depends on `@foo` (such as a dependency on `@foo//some:target`, it should actually resolve that dependency within globally-declared `@bar` (`@bar//some:target`).<br><br>This attribute is _not_ supported in `MODULE.bazel` context (when invoking a repository rule inside a module extension's implementation function).   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  |
| <a id="download_sdk-sha256"></a>sha256 |  SDK package checksum   | String | optional |  `""`  |
| <a id="download_sdk-url"></a>url |  URL to download the SDK package from.<br><br>Can be empty, in this case the download URL will be inherited from the provided version.   | String | required |  |
| <a id="download_sdk-version"></a>version |  Vulkan SDK version to download and install.<br><br>This expects a version in the format of `1.4.313.0` or `1.4.313`. When 3 components are provided, `.0` will be appended automatically to make it 4 components.   | String | required |  |
| <a id="download_sdk-windows_skip_runtime"></a>windows_skip_runtime |  Do not download and install Vulkan runtime package (e.g. `vulkan-1.dll` dependency) on Windows.<br><br>When `True`, the downloader with put `vulkan-1.dll` into the repository root directory.<br><br>This is useful if there is a system-wide Vulkan runtime already installed, otherwise this might lead to link/runtime issues when building CC targets.   | Boolean | optional |  `False`  |


