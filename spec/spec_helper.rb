# frozen_string_literal: true

require "bundler/setup"
require "simplecov"
require "pry"
require "pry-byebug"
require "climate_control"
require "gemsmith"

SimpleCov.start

Dir[File.join(File.dirname(__FILE__), "support/shared_contexts/**/*.rb")].each do |file|
  require file
end

RSpec.configure do |config|
  config.color = true
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
  config.filter_run_when_matching :focus
  config.formatter = ENV["CI"] == "true" ? :progress : :documentation
  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }
  config.order = "random"
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.warnings = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end
