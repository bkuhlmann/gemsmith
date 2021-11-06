# frozen_string_literal: true

require_relative "lib/gemsmith/identity"

Gem::Specification.new do |spec|
  spec.name = Gemsmith::Identity::NAME
  spec.version = Gemsmith::Identity::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://www.alchemists.io/projects/gemsmith"
  spec.summary = "A command line interface for smithing Ruby gems."
  spec.license = "Apache-2.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/gemsmith/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/gemsmith/changes.html",
    "documentation_uri" => "https://www.alchemists.io/projects/gemsmith",
    "source_code_uri" => "https://github.com/bkuhlmann/gemsmith"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.0"
  spec.add_dependency "git_plus", "~> 0.6"
  spec.add_dependency "milestoner", "~> 12.0"
  spec.add_dependency "pragmater", "~> 9.0"
  spec.add_dependency "refinements", "~> 8.5"
  spec.add_dependency "rubocop", "~> 1.20"
  spec.add_dependency "runcom", "~> 7.0"
  spec.add_dependency "thor", "~> 0.20"
  spec.add_dependency "tocer", "~> 12.1"
  spec.add_dependency "versionaire", "~> 9.0"
  spec.add_dependency "zeitwerk", "~> 2.5"

  spec.bindir = "exe"
  spec.executables << "gemsmith"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir.glob "lib/**/*", File::FNM_DOTMATCH
  spec.require_paths = ["lib"]
end
