# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "tester"
  spec.version = "0.0.0"
  spec.authors = ["Example Author"]
  spec.summary = "A summary."

  spec.metadata = {
    "label" => "Test",
    "allowed_push_key" => "test",
    "allowed_push_host" => "https://www.test.com",
    "rubygems_mfa_required" => "true"
  }
end
