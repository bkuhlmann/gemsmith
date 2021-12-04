# frozen_string_literal: true

RSpec.shared_examples "a parser" do
  describe ".call" do
    it "answers configuration" do
      parser = described_class.call client: OptionParser.new
      expect(parser).to be_a(Rubysmith::Configuration::Content)
    end
  end
end
