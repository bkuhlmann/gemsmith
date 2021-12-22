Gem::Specification.new do |spec|
  spec.name = "test"
  spec.version = "0.0.0"
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Jill Smith"]
  spec.email = ["jill@example.com"]
  spec.homepage = "https://www.example.com/test"
  spec.summary = ""
  spec.license = "Hippocratic-3.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://www.example.com/test/issues",
    "changelog_uri" => "https://www.example.com/test/versions",
    "documentation_uri" => "https://www.example.com/test",
    "label" => "Test",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://www.example.com/test/source"
  }

  spec.required_ruby_version = "~> 3.1"
  spec.add_dependency "dry-container", "~> 0.9"
  spec.add_dependency "pastel", "~> 0.8"
  spec.add_dependency "refinements", "~> 9.1"
  spec.add_dependency "runcom", "~> 8.0"
  spec.add_dependency "zeitwerk", "~> 2.5"

  spec.bindir = "exe"
  spec.executables << "test"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
  spec.require_paths = ["lib"]
end