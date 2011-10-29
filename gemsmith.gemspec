# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gemsmith/version"

Gem::Specification.new do |s|
  s.name        = "gemsmith"
  s.version     = Gemsmith::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = "Brooke Kuhlmann"
  s.email       = "brooke@redalchemist.com"
  s.homepage    = "http://www.redalchemist.com"
  s.summary     = "Ruby gem skeleton generation for the professional gemsmith."
  s.description = "Ruby gem skeleton generation for the professional gemsmith. Includes custom settings, binary, Ruby on Rails, and RSpec support. "

  s.rdoc_options << "CHANGELOG.rdoc"
  s.required_ruby_version = "~> 1.9.0"
  s.add_dependency "thor", "~> 0.14.0"
  s.add_dependency "thor_plus", ">= 0.1.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "aruba"
  s.executables << "gemsmith"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

