Gem::Specification.new do |spec|
  spec.name = "test"
  spec.version = "0.0.0"
  spec.authors = ["Jill Smith"]
  spec.email = ["jill@acme.io"]
  spec.homepage = ""
  spec.summary = ""
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "label" => "Test",
    "rubygems_mfa_required" => "true"
  }

  spec.required_ruby_version = "~> 3.3"
  spec.add_dependency "cogger", "~> 0.21"
  spec.add_dependency "containable", "~> 0.2"
  spec.add_dependency "dry-monads", "~> 1.6"
  spec.add_dependency "etcher", "~> 2.1"
  spec.add_dependency "infusible", "~> 3.8"
  spec.add_dependency "refinements", "~> 12.7"
  spec.add_dependency "runcom", "~> 11.5"
  spec.add_dependency "sod", "~> 0.12"
  spec.add_dependency "spek", "~> 3.0"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.bindir = "exe"
  spec.executables << "test"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
