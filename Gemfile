# frozen_string_literal: true

ruby file: ".ruby-version"

source "https://rubygems.org"

gemspec

group :quality do
  gem "caliber", "~> 0.47"
  gem "git-lint", "~> 7.0"
  gem "reek", "~> 6.2", require: false
  gem "simplecov", "~> 0.22", require: false
end

group :development do
  gem "rake", "~> 13.1"
end

group :test do
  gem "guard-rspec", "~> 4.7", require: false
  gem "rspec", "~> 3.12"
end

group :tools do
  gem "amazing_print", "~> 1.5"
  gem "debug", "~> 1.9"
end
