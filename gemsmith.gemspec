# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "gemsmith"
  spec.version = "24.1.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/gemsmith"
  spec.summary = "A command line interface for smithing Ruby gems."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/gemsmith/issues",
    "changelog_uri" => "https://alchemists.io/projects/gemsmith/versions",
    "homepage_uri" => "https://alchemists.io/projects/gemsmith",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Gemsmith",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/gemsmith"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = ">= 4.0"

  spec.add_dependency "cogger", "~> 2.0"
  spec.add_dependency "containable", "~> 2.0"
  spec.add_dependency "core", "~> 3.0"
  spec.add_dependency "dry-monads", "~> 1.9"
  spec.add_dependency "dry-schema", "~> 1.15"
  spec.add_dependency "etcher", "~> 4.0"
  spec.add_dependency "infusible", "~> 5.0"
  spec.add_dependency "milestoner", "~> 20.0"
  spec.add_dependency "refinements", "~> 14.0"
  spec.add_dependency "rubysmith", "~> 9.1"
  spec.add_dependency "runcom", "~> 13.0"
  spec.add_dependency "sod", "~> 2.0"
  spec.add_dependency "spek", "~> 5.0"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.bindir = "exe"
  spec.executables << "gemsmith"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir.glob ["*.gemspec", "lib/**/*"], File::FNM_DOTMATCH
end
