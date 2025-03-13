# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Tools::Publisher do
  subject(:publisher) { described_class.new steps: }

  include_context "with application dependencies"

  describe "#call" do
    context "when success" do
      let(:steps) { [proc { Success(specification) }, proc { Success(specification) }] }

      it "answers specification" do
        result = publisher.call specification
        expect(result.success).to eq(specification)
      end
    end

    context "when failure" do
      let(:steps) { [proc { Failure "Danger!" }, proc { Success(specification) }] }

      it "answers failure" do
        result = publisher.call specification
        expect(result.failure).to eq("Danger!")
      end
    end
  end
end
