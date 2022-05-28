# frozen_string_literal: true

require "bundler/setup"
require "git/lint/rake/setup"
require "reek/rake/task"
require "rspec/core/rake_task"
require "rubocop/rake_task"

Reek::Rake::Task.new
RSpec::Core::RakeTask.new :spec
RuboCop::RakeTask.new

desc "Run code quality checks"
task code_quality: %i[git_lint reek rubocop]

task default: %i[code_quality spec]
