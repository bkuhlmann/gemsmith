# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI::Parser do
  subject(:parser) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers hash with valid option" do
      expect(parser.call(%w[--help])).to have_attributes(action_help: true)
    end

    it "fails with invalid option" do
      expectation = proc { parser.call %w[--bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidOption, /--bogus/)
    end
  end

  describe "#to_s" do
    it "answers usage" do
      parser.call
      expect(parser.to_s).to match(/.+USAGE.+BUILD\sOPTIONS.+/m)
    end
  end
end
