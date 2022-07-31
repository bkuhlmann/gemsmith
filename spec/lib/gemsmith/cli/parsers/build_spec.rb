# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI::Parsers::Build do
  subject(:parser) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a parser"

  describe "#call" do
    let(:test_configuration) { configuration.minimize.dup }

    it "enables CLI" do
      expect(parser.call(%w[--cli])).to have_attributes(
        build_cli: true,
        build_refinements: true,
        build_zeitwerk: true
      )
    end

    it "disables CLI" do
      expect(parser.call(%w[--no-cli])).to have_attributes(
        build_cli: false,
        build_refinements: false,
        build_zeitwerk: false
      )
    end

    it "fails with invalid option" do
      expectation = proc { parser.call %w[--bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidOption, /--bogus/)
    end

    context "with maximum configuration" do
      let(:test_configuration) { configuration.maximize.dup }

      it "disables CLI" do
        expect(parser.call(%w[--no-cli])).to have_attributes(
          build_cli: false,
          build_refinements: true,
          build_zeitwerk: true
        )
      end
    end
  end
end
