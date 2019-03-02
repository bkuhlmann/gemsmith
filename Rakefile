# frozen_string_literal: true

begin
  require "bundler/audit/task"
  require "gemsmith/rake/setup"
  require "git/cop/rake/setup"
  require "rspec/core/rake_task"
  require "reek/rake/task"
  require "rubocop/rake_task"

  Bundler::Audit::Task.new
  RSpec::Core::RakeTask.new :spec
  Reek::Rake::Task.new
  RuboCop::RakeTask.new
rescue LoadError => error
  puts error.message
end

desc "Run code quality checks"
task code_quality: %i[bundle:audit git_cop reek rubocop]

task default: %i[code_quality spec]
