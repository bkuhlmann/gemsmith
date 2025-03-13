# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Tools::Validator do
  subject(:validator) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers specification when success" do
      result = validator.call specification
      expect(result.success).to eq(specification)
    end

    context "when invalid" do
      let :executor do
        class_double Open3, capture3: ["", "", instance_double(Process::Status, success?: false)]
      end

      it "answers failure" do
        result = validator.call specification
        expect(result.failure).to eq("Project has uncommitted changes.")
      end
    end
  end
end
