require "spec_helper"

RSpec.describe Test::Configuration::Loader do
  subject(:loader) { described_class.with_defaults }

  let(:content) { Test::Configuration::Content.new }

  describe ".call" do
    it "answers default configuration" do
      expect(described_class.call).to be_a(Test::Configuration::Content)
    end
  end

  describe ".with_defaults" do
    it "answers default configuration" do
      expect(described_class.with_defaults.call).to eq(content)
    end
  end

  describe "#call" do
    it "answers default configuration" do
      expect(loader.call).to eq(content)
    end

    it "answers frozen configuration" do
      expect(loader.call).to be_frozen
    end
  end
end
