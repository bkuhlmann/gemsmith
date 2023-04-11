require "dry/container/stub"
require "infusible/stub"

RSpec.shared_context "with application dependencies" do
  using Refinements::Structs
  using Infusible::Stub

  include_context "with temporary directory"

  let(:configuration) { Test::Configuration::Loader.with_defaults.call }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new io: StringIO.new, formatter: :emoji }

  before { Test::Import.stub configuration:, kernel:, logger: }

  after { Test::Import.unstub :configuration, :kernel, :logger }
end
