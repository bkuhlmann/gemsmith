# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "gemsmith"
  spec.version = "17.0.1"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://www.alchemists.io/projects/gemsmith"
  spec.summary = "A command line interface for smithing Ruby gems."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/gemsmith/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/gemsmith/versions",
    "documentation_uri" => "https://www.alchemists.io/projects/gemsmith",
    "label" => "Gemsmith",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/gemsmith"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.1"
  spec.add_dependency "dry-container", "~> 0.9"
  spec.add_dependency "dry-monads", "~> 1.4"
  spec.add_dependency "milestoner", "~> 13.3"
  spec.add_dependency "pastel", "~> 0.8"
  spec.add_dependency "refinements", "~> 9.2"
  spec.add_dependency "rubysmith", "~> 2.0"
  spec.add_dependency "runcom", "~> 8.2"
  spec.add_dependency "spek", "~> 0.2"
  spec.add_dependency "versionaire", "~> 10.0"
  spec.add_dependency "zeitwerk", "~> 2.5"

  spec.bindir = "exe"
  spec.executables << "gemsmith"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir.glob ["*.gemspec", "lib/**/*"], File::FNM_DOTMATCH
end
