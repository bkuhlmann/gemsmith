require "dry/container/stub"
require "infusible/stub"

RSpec.shared_context "with application dependencies" do
  using Refinements::Structs
  using Infusible::Stub

  include_context "with temporary directory"

  let(:configuration) { Test::Configuration::Loader.with_defaults.call }
  let(:kernel) { class_spy Kernel }

  let :logger do
    Cogger::Client.new Logger.new(StringIO.new),
                       formatter: -> _severity, _name, _at, message { "#{message}\n" }
  end

  before { Test::Import.stub configuration:, kernel:, logger: }

  after { Test::Import.unstub :configuration, :kernel, :logger }
end
