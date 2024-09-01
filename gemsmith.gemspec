# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "gemsmith"
  spec.version = "22.4.0"
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

  spec.required_ruby_version = ">= 3.3", "<= 3.4"
  spec.add_dependency "cogger", "~> 0.26"
  spec.add_dependency "containable", "~> 0.2"
  spec.add_dependency "core", "~> 1.0"
  spec.add_dependency "dry-monads", "~> 1.6"
  spec.add_dependency "dry-schema", "~> 1.13"
  spec.add_dependency "etcher", "~> 2.1"
  spec.add_dependency "infusible", "~> 3.8"
  spec.add_dependency "milestoner", "~> 18.0"
  spec.add_dependency "refinements", "~> 12.7"
  spec.add_dependency "rubysmith", "~> 7.4"
  spec.add_dependency "runcom", "~> 11.5"
  spec.add_dependency "sod", "~> 0.14"
  spec.add_dependency "spek", "~> 3.0"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.bindir = "exe"
  spec.executables << "gemsmith"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir.glob ["*.gemspec", "lib/**/*"], File::FNM_DOTMATCH
end
