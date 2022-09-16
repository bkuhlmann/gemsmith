Gem::Specification.new do |spec|
  spec.name = "test"
  spec.version = "0.0.0"
  spec.authors = ["Jill Smith"]
  spec.email = [""]
  spec.homepage = ""
  spec.summary = ""
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "label" => "Test",
    "rubygems_mfa_required" => "true"
  }

  spec.required_ruby_version = "~> 3.1"
  spec.add_dependency "dry-container", "~> 0.11"
  spec.add_dependency "infusible", "~> 0.0"
  spec.add_dependency "refinements", "~> 9.6"
  spec.add_dependency "runcom", "~> 8.5"
  spec.add_dependency "spek", "~> 0.5"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.bindir = "exe"
  spec.executables << "test"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
