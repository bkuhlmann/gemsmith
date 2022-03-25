require "dry/container/stub"

RSpec.shared_context "with application container" do
  using Refinements::Structs

  include_context "with temporary directory"

  let(:container) { Test::Container }
  let(:configuration) { Test::Configuration::Loader.with_defaults.call }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Logger.new io, formatter: ->(_severity, _name, _at, message) { "#{message}\n" } }
  let(:io) { StringIO.new }

  before do
    container.enable_stubs!
    container.stub :configuration, configuration
    container.stub :kernel, kernel
    container.stub :logger, logger
  end

  after do
    container.unstub :configuration
    container.unstub :kernel
    container.unstub :logger
  end
end
