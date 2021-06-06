# frozen_string_literal: true

require "bundler/setup"
Bundler.require :tools

require "simplecov"
SimpleCov.start { enable_coverage :branch }

require "git_plus/spec/shared_contexts/temp_dir"
require "git_plus/spec/shared_contexts/git_repo"
require "refinements"
require "climate_control"
require "gemsmith"

GC.auto_compact = true
GC.verify_compaction_references double_heap: true, toward: :empty

RSpec.configure do |config|
  config.color = true
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
  config.filter_run_when_matching :focus
  config.formatter = ENV["CI"] == "true" ? :progress : :documentation
  config.order = :random
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.warnings = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end
end
