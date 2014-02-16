require "bundler/setup"
require "gemsmith"
require "gemsmith/cli"
require "pry"
require "pry-remote"
require "pry-rescue"
require "pry-vterm_aliases"

case Gem.ruby_engine
  when "ruby"
    require "pry-byebug"
    require "pry-stack_explorer"
  when "jruby"
    require "pry-nav"
  when "rbx"
    require "pry-nav"
    require "pry-stack_explorer"
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run focus: true
end
