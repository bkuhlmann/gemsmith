# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "test"
  spec.version = "0.0.0"
  spec.authors = ["Jill Smith"]
  spec.summary = "A test gem."

  spec.metadata = {
    "label" => "Test",
    "allowed_push_key" => "test",
    "allowed_push_host" => "https://www.test.com",
    "rubygems_mfa_required" => "true"
  }
end
