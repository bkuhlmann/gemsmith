Gem::Specification.new do |spec|
  spec.name = "test"
  spec.version = "0.0.0"
  spec.authors = ["Jill Smith"]
  spec.email = ["jill@example.com"]
  spec.homepage = "https://www.example.com/test"
  spec.summary = ""
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://www.example.com/test/issues",
    "changelog_uri" => "https://www.example.com/test/versions",
    "documentation_uri" => "https://www.example.com/test",
    "funding_uri" => "https://www.example.com/test/funding",
    "label" => "Test",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://www.example.com/test/source"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.2"
  spec.add_dependency "cogger", "~> 0.5"
  spec.add_dependency "dry-container", "~> 0.11"
  spec.add_dependency "infusible", "~> 1.0"
  spec.add_dependency "refinements", "~> 10.0"
  spec.add_dependency "runcom", "~> 9.0"
  spec.add_dependency "spek", "~> 1.0"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.bindir = "exe"
  spec.executables << "test"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
