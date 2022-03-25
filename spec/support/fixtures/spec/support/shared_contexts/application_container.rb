require "dry/container/stub"
require "auto_injector/stub"

RSpec.shared_context "with application container" do
  using Refinements::Structs
  using AutoInjector::Stub

  include_context "with temporary directory"

  let(:configuration) { Test::Configuration::Loader.with_defaults.call }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Logger.new io, formatter: ->(_severity, _name, _at, message) { "#{message}\n" } }
  let(:io) { StringIO.new }

  before { Test::Import.stub configuration:, kernel:, logger: }

  after { Test::Import.unstub configuration:, kernel:, logger: }
end
