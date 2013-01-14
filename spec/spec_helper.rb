require "bundler/setup"
require "gemsmith"
require File.join "gemsmith", "cli"

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
