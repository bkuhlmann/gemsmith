# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks"
require "bundler/plumber/task"
require "git/lint/rake/setup"
require "reek/rake/task"
require "rspec/core/rake_task"
require "rubocop/rake_task"

Bundler::Plumber::Task.new
Reek::Rake::Task.new
RSpec::Core::RakeTask.new :spec
RuboCop::RakeTask.new

desc "Run code quality checks"
task code_quality: %i[bundle:leak git_lint reek rubocop]

task default: %i[code_quality spec]
