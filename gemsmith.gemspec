# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gemsmith/version"

Gem::Specification.new do |s|
  s.name                  = "gemsmith"
  s.version               = Gemsmith::VERSION
  s.platform              = Gem::Platform::RUBY
  s.author                = "Brooke Kuhlmann"
  s.email                 = "brooke@redalchemist.com"
  s.homepage              = "http://www.redalchemist.com"
  s.summary               = "Ruby gem skeleton generation for the professional gemsmith."
  s.description           = "Ruby gem skeleton generation for the professional gemsmith. Includes custom settings, binary, Ruby on Rails, and RSpec support. "
  s.license               = "MIT"
  s.post_install_message	= "(W): www.redalchemist.com. (T): @ralchemist."

  s.required_ruby_version = "~> 1.9.0"
  s.add_dependency "thor", "~> 0.14.0"
  s.add_dependency "thor_plus", ">= 0.2.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "aruba"

  s.files         = Dir["lib/**/*"] + %w(README* CHANGELOG* LICENSE*)
  s.test_files    = Dir["{spec, features}/**/*"]
  s.executables << "gemsmith"
  s.require_paths = ["lib"]
end

