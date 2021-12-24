# frozen_string_literal: true

ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gemspec

group :code_quality do
  gem "bundler-leak", "~> 0.2"
  gem "git-lint", "~> 2.0"
  gem "reek", "~> 6.0"
  gem "rubocop", "~> 1.25"
  gem "rubocop-performance", "~> 1.12"
  gem "rubocop-rake", "~> 0.6"
  gem "rubocop-rspec", "~> 2.6"
  gem "simplecov", "~> 0.20"
end

group :development do
  gem "rake", "~> 13.0"
end

group :test do
  gem "guard-rspec", "~> 4.7", require: false
  gem "rspec", "~> 3.10"
end

group :tools do
  gem "amazing_print", "~> 1.3"
  gem "debug", "~> 1.1"
end
