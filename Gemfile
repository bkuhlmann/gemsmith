# frozen_string_literal: true

ruby file: ".ruby-version"

source "https://rubygems.org"

gemspec

group :quality do
  gem "caliber", "~> 0.82"
  gem "git-lint", "~> 9.0"
  gem "reek", "~> 6.5", require: false
  gem "simplecov", "~> 0.22", require: false
end

group :development do
  gem "rake", "~> 13.3"
end

group :test do
  gem "rspec", "~> 3.13"
  gem "warning", "~> 1.5"
end

group :tools do
  gem "amazing_print", "~> 2.0"
  gem "debug", "~> 1.11"
  gem "irb-kit", "~> 1.1"
  gem "repl_type_completor", "~> 0.1"
end
