# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Gemsmith::Tools::Versioner do
  using Refinements::Structs
  using Versionaire::Cast

  subject(:versioner) { described_class.new publisher: }

  include_context "with application dependencies"

  let(:publisher) { instance_spy Milestoner::Tags::Publisher }

  describe "#call" do
    it "answers publishes version when success" do
      versioner.call specification

      expect(publisher).to have_received(:call).with(
        Milestoner::Configuration::Model[
          documentation_format: "adoc",
          prefixes: %w[Fixed Added Updated Removed Refactored],
          version: Version("0.0.0")
        ]
      )
    end

    it "answers specification when success" do
      result = versioner.call specification
      expect(result.success).to eq(specification)
    end

    it "answers error when failure" do
      allow(publisher).to receive(:call).and_raise(Milestoner::Error, "Danger!")
      result = versioner.call specification

      expect(result.failure).to eq("Danger!")
    end
  end
end
