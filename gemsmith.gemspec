# frozen_string_literal: true

$LOAD_PATH.append File.expand_path("lib", __dir__)
require "gemsmith/identity"

Gem::Specification.new do |spec|
  spec.name = Gemsmith::Identity.name
  spec.version = Gemsmith::Identity.version
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = Gemsmith::Identity.url
  spec.summary = "A command line interface for smithing new Ruby gems."
  spec.license = "Apache-2.0"

  spec.metadata = {
    "source_code_uri" => "https://github.com/bkuhlmann/gemsmith",
    "changelog_uri" => "https://github.com/bkuhlmann/gemsmith/blob/master/CHANGES.md",
    "bug_tracker_uri" => "https://github.com/bkuhlmann/gemsmith/issues"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 2.6"
  spec.add_dependency "milestoner", "~> 9.3"
  spec.add_dependency "pragmater", "~> 6.3"
  spec.add_dependency "refinements", "~> 6.0"
  spec.add_dependency "rubocop", "~> 0.75"
  spec.add_dependency "runcom", "~> 5.0"
  spec.add_dependency "thor", "~> 0.20"
  spec.add_dependency "tocer", "~> 9.1"
  spec.add_dependency "versionaire", "~> 7.2"
  spec.add_development_dependency "awesome_print", "~> 1.8"
  spec.add_development_dependency "bond", "~> 0.5"
  spec.add_development_dependency "bundler-audit", "~> 0.6"
  spec.add_development_dependency "climate_control", "~> 0.2"
  spec.add_development_dependency "git-cop", "~> 3.5"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "hirb", "~> 0.7"
  spec.add_development_dependency "pry", "~> 0.12"
  spec.add_development_dependency "pry-byebug", "~> 3.7"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "reek", "~> 5.4"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rubocop-performance", "~> 1.4"
  spec.add_development_dependency "rubocop-rspec", "~> 1.33"
  spec.add_development_dependency "simplecov", "~> 0.16"
  spec.add_development_dependency "wirb", "~> 2.1"

  spec.files = Dir.glob "lib/**/*", File::FNM_DOTMATCH
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.executables << "gemsmith"
  spec.require_paths = ["lib"]
end
