# frozen_string_literal: true

begin
  require "gemsmith/rake/setup"
rescue LoadError => error
  puts error.message
end

Dir.glob("lib/tasks/*.rake").each { |file| load file }

task default: %w[spec reek rubocop]
