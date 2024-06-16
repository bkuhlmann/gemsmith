Gem::Specification.new do |spec|
  spec.name = "test"
  spec.version = "0.0.0"
  spec.authors = ["Jill Smith"]
  spec.email = ["jill@acme.io"]
  spec.homepage = "https://acme.io/test"
  spec.summary = ""
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://acme.io/test/issues",
    "changelog_uri" => "https://acme.io/test/versions",
    "documentation_uri" => "https://acme.io/test",
    "funding_uri" => "https://acme.io/test/funding",
    "label" => "Test",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://acme.io/test/source"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.3"
  spec.add_dependency "cogger", "~> 0.21"
  spec.add_dependency "containable", "~> 0.0"
  spec.add_dependency "dry-monads", "~> 1.6"
  spec.add_dependency "etcher", "~> 1.6"
  spec.add_dependency "infusible", "~> 3.5"
  spec.add_dependency "refinements", "~> 12.1"
  spec.add_dependency "runcom", "~> 11.0"
  spec.add_dependency "sod", "~> 0.8"
  spec.add_dependency "spek", "~> 3.0"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.bindir = "exe"
  spec.executables << "test"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
