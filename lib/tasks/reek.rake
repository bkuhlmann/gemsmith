# frozen_string_literal: true

begin
  require "reek/rake/task"
  Reek::Rake::Task.new
rescue LoadError => error
  puts error.message
end
