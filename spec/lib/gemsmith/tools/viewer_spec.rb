# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Tools::Viewer do
  subject(:viewer) { described_class.new }

  include_context "with application container"

  describe "#call" do
    it "answers specification when success" do
      result = viewer.call specification
      expect(result.success).to eq(specification)
    end

    context "with failure" do
      let :executor do
        class_double Open3,
                     capture3: ["", "Error.", instance_double(Process::Status, success?: false)]
      end

      it "answers standard error" do
        result = viewer.call specification
        expect(result.failure).to eq("Error.")
      end
    end
  end
end
