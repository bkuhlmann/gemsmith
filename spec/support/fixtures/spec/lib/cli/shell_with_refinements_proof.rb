require "spec_helper"

RSpec.describe Test::CLI::Shell do
  using Refinements::Pathname
  using Refinements::StringIO

  subject(:shell) { described_class.new }

  include_context "with application dependencies"

  before { Sod::Container.stub! logger:, io: }

  after { Sod::Container.restore }

  describe "#call" do
    it "prints configuration usage" do
      shell.call %w[config]
      expect(io.reread).to match(/Manage configuration.+/m)
    end

    it "prints version" do
      shell.call %w[--version]
      expect(io.reread).to match(/Test\s\d+\.\d+\.\d+/)
    end

    it "prints help" do
      shell.call %w[--help]
      expect(io.reread).to match(/Test.+USAGE.+/m)
    end
  end
end
