require "bundler/setup"
require "gemsmith"
require "gemsmith/cli"
require "pry"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
end
