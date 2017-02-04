# frozen_string_literal: true

require "bundler/setup"
require "simplecov"
SimpleCov.start

require "pry"
require "pry-byebug"
require "pry-state"
require "climate_control"
require "gemsmith"

Dir[File.join(File.dirname(__FILE__), "support/shared_contexts/**/*.rb")].each do |file|
  require file
end

RSpec.configure do |config|
  config.color = true
  config.order = "random"
  config.disable_monkey_patching!
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "./tmp/rspec-status.txt"
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  $stdout = File.new("/dev/null", "w") if ENV["SUPPRESS_STDOUT"] == "enabled"
  $stderr = File.new("/dev/null", "w") if ENV["SUPPRESS_STDERR"] == "enabled"
end
