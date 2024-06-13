# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Tools::Versioner do
  include Dry::Monads[:result]

  subject(:versioner) { described_class.new publisher: }

  include_context "with application dependencies"

  let(:publisher) { instance_spy Milestoner::Tags::Publisher, call: Success(specification) }

  describe "#call" do
    it "delegates to publisher" do
      versioner.call specification
      expect(publisher).to have_received(:call).with(/0.0.0/)
    end

    it "answers specification when success" do
      expect(versioner.call(specification)).to eq(Success(specification))
    end

    it "answers failure when publish fails" do
      allow(publisher).to receive(:call).and_return(Failure("Danger!"))
      expect(versioner.call(specification)).to eq(Failure("Danger!"))
    end
  end
end
