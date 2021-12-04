require "dry/container/stub"

RSpec.shared_context "with application container" do
  using Refinements::Structs

  include_context "with temporary directory"

  let(:container) { Test::Container }
  let(:configuration) { Test::Configuration::Loader.with_defaults.call }
  let(:kernel) { class_spy Kernel }

  before do
    container.enable_stubs!
    container.stub :configuration, configuration
    container.stub :kernel, kernel
  end

  after do
    container.unstub :configuration
    container.unstub :kernel
  end
end
