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

  spec.required_ruby_version = ">= 4.0"
  spec.add_dependency "cogger", "~> 1.0"
  spec.add_dependency "containable", "~> 1.1"
  spec.add_dependency "dry-monads", "~> 1.9"
  spec.add_dependency "etcher", "~> 3.0"
  spec.add_dependency "infusible", "~> 4.0"
  spec.add_dependency "refinements", "~> 14.0"
  spec.add_dependency "runcom", "~> 12.0"
  spec.add_dependency "sod", "~> 1.5"
  spec.add_dependency "spek", "~> 5.0"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.bindir = "exe"
  spec.executables << "test"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
