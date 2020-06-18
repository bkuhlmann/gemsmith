# frozen_string_literal: true

require "bundler/audit/task"
require "gemsmith/rake/setup"
require "git/lint/rake/setup"
require "rspec/core/rake_task"
require "reek/rake/task"
require "rubocop/rake_task"

Bundler::Audit::Task.new
RSpec::Core::RakeTask.new :spec
Reek::Rake::Task.new
RuboCop::RakeTask.new

desc "Run code quality checks"
task code_quality: %i[bundle:audit git_lint reek rubocop]

task default: %i[code_quality spec]
