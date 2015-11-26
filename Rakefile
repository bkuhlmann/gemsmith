require "gemsmith/rake/setup"
Dir.glob("lib/tasks/*.rake").each { |file| load file }

task default: %w(spec rubocop)
