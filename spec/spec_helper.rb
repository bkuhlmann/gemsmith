require "bundler/setup"
require "gemsmith"
require "gemsmith/cli"
require "pry"
require "pry-byebug"
require "pry-remote"
require "pry-rescue"
require "pry-stack_explorer"
require "pry-vterm_aliases"
require "pry-git"
require "pry-doc"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run focus: true
end
