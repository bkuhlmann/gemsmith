# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Gemsmith::Tools::Versioner do
  using Refinements::Structs
  using Versionaire::Cast

  subject(:versioner) { described_class.new client: }

  include_context "with application container"

  let(:client) { instance_spy Milestoner::Tags::Publisher }

  describe "#call" do
    it "answers publishes version when success" do
      versioner.call specification

      expect(client).to have_received(:call).with(
        Milestoner::Configuration::Loader.with_defaults.call.merge(version: Version("0.0.0"))
      )
    end

    it "answers specification when success" do
      result = versioner.call specification
      expect(result.success).to eq(specification)
    end

    it "answers error when failure" do
      allow(client).to receive(:call).and_raise(Milestoner::Error, "Danger!")
      result = versioner.call specification

      expect(result.failure).to eq("Danger!")
    end
  end
end
