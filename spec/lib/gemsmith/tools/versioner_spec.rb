# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Tools::Versioner do
  subject(:versioner) { described_class.new publisher: }

  include_context "with application dependencies"

  let(:publisher) { instance_spy Milestoner::Tags::Publisher }

  describe "#call" do
    it "answers publishes version when success" do
      versioner.call specification
      expect(publisher).to have_received(:call).with(/0.0.0/)
    end

    it "answers specification when success" do
      expect(versioner.call(specification).success).to eq(specification)
    end

    it "answers error when failure" do
      allow(publisher).to receive(:call).and_raise(Milestoner::Error, "Danger!")
      result = versioner.call specification

      expect(result.failure).to eq("Danger!")
    end
  end
end
