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

  s.required_ruby_version = "~> 2.0.0"
  s.add_dependency "thor", "~> 0.18"
  s.add_dependency "thor_plus", "~> 1.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-debugger"
  s.add_development_dependency "pry-rescue"
  s.add_development_dependency "pry-stack_explorer"
  s.add_development_dependency "pry-vterm_aliases"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rb-fsevent" # Guard file events for OSX.
  s.add_development_dependency "rb-inotify" # Guard file events for Linux.
  s.add_development_dependency "guard-rspec"

  s.files            = Dir["lib/**/{*,.*}"]
  s.extra_rdoc_files = Dir["README*", "LICENSE*"]
  s.executables      << "gemsmith"
  s.require_paths    = ["lib"]
end

