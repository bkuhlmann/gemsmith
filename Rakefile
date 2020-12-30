# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks"
require "bundler/audit/task"
require "bundler/plumber/task"
# require "gemsmith/rake/setup"
require "git/lint/rake/setup"
require "reek/rake/task"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "rubycritic/rake_task"

Bundler::Audit::Task.new
Bundler::Plumber::Task.new
Reek::Rake::Task.new
RSpec::Core::RakeTask.new :spec
RuboCop::RakeTask.new
RubyCritic::RakeTask.new

desc "Run code quality checks"
task code_quality: %i[bundle:audit bundle:leak git_lint reek rubocop rubycritic]

task default: %i[code_quality spec]
