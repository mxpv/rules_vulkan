package hlsl

import (
	"flag"
	"fmt"
	"strings"

	"github.com/bazelbuild/bazel-gazelle/config"
	"github.com/bazelbuild/bazel-gazelle/label"
	"github.com/bazelbuild/bazel-gazelle/language"
	"github.com/bazelbuild/bazel-gazelle/repo"
	"github.com/bazelbuild/bazel-gazelle/resolve"
	"github.com/bazelbuild/bazel-gazelle/rule"
)

type hlslLang struct{}

func NewLanguage() language.Language {
	return &hlslLang{}
}

func (*hlslLang) Name() string {
	return "hlsl"
}

func (*hlslLang) RegisterFlags(fs *flag.FlagSet, cmd string, c *config.Config) {
}

func (*hlslLang) CheckFlags(fs *flag.FlagSet, c *config.Config) error {
	return nil
}

func (*hlslLang) KnownDirectives() []string {
	return []string{}
}

func (*hlslLang) Configure(c *config.Config, rel string, f *rule.File) {
}

func (*hlslLang) Kinds() map[string]rule.KindInfo {
	return map[string]rule.KindInfo{
		"hlsl_shader": {
			// Match by src + entry + target because multiple shader stages
			// (vertex, pixel, compute) can be compiled from the same HLSL file
			// with different entry points and profiles.
			MatchAttrs: []string{"src", "entry", "target"},
			NonEmptyAttrs: map[string]bool{
				"defines": true,
				"opts":    true,
				"hlsl":    true,
			},
			MergeableAttrs: map[string]bool{
				"hdrs": true,
			},
			ResolveAttrs: map[string]bool{
				"hdrs": true,
			},
		},
	}
}

func (*hlslLang) Loads() []rule.LoadInfo {
	return []rule.LoadInfo{}
}

func (*hlslLang) ApparentLoads(moduleToApparentName func(string) string) []rule.LoadInfo {
	// Get the apparent repository name for rules_vulkan
	rulesVulkanRepo := moduleToApparentName("rules_vulkan")
	if rulesVulkanRepo == "" {
		// Fallback to legacy WORKSPACE name if not using bzlmod
		rulesVulkanRepo = "rules_vulkan"
	}

	return []rule.LoadInfo{
		{
			Name:    fmt.Sprintf("@%s//vulkan:defs.bzl", rulesVulkanRepo),
			Symbols: []string{"hlsl_shader"},
		},
	}
}

func (*hlslLang) GenerateRules(args language.GenerateArgs) language.GenerateResult {
	var rules []*rule.Rule
	var imports []interface{}

	// Find all .hlsl files
	for _, f := range args.RegularFiles {
		if !strings.HasSuffix(f, ".hlsl") {
			continue
		}

		// Generate a rule name from the filename (remove .hlsl extension)
		name := strings.TrimSuffix(f, ".hlsl")

		// Create an hlsl_shader rule
		r := rule.NewRule("hlsl_shader", name)
		r.SetAttr("src", f)
		// Set default mandatory attributes
		r.SetAttr("entry", "main")
		r.SetAttr("target", "cs_6_0")

		rules = append(rules, r)
		// One import entry per rule (nil for now, imports not processed yet)
		imports = append(imports, nil)
	}

	return language.GenerateResult{
		Gen:     rules,
		Imports: imports,
	}
}

func (*hlslLang) Fix(c *config.Config, f *rule.File) {}

func (*hlslLang) Imports(c *config.Config, r *rule.Rule, f *rule.File) []resolve.ImportSpec {
	return []resolve.ImportSpec{}
}

func (*hlslLang) Embeds(r *rule.Rule, from label.Label) []label.Label {
	return []label.Label{}
}

func (*hlslLang) Resolve(c *config.Config, ix *resolve.RuleIndex, rc *repo.RemoteCache, r *rule.Rule, imports interface{}, from label.Label) {
}
