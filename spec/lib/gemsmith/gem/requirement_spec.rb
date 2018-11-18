# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Gem::Requirement do
  subject(:requirement) { described_class.new }

  describe ".version_segments" do
    context "with one segment" do
      it "answers array of one segment integer" do
        expect(described_class.version_segments("0")).to contain_exactly(0)
      end
    end

    context "with multiple segments" do
      it "answers array of multiple segment integers" do
        expect(described_class.version_segments("1.2.3")).to contain_exactly(1, 2, 3)
      end
    end

    context "with version" do
      it "answers array of multiple segment integers" do
        version = Versionaire::Version.new
        expect(described_class.version_segments(version)).to contain_exactly(0, 0, 0)
      end
    end
  end

  describe ".for" do
    context "with string" do
      it "creates new gem requirement" do
        expect(described_class.for("~> 1.2").to_s).to eq("~> 1.2.0")
      end
    end

    context "with invalid object" do
      it "fails with requirement conversion error" do
        result = -> { described_class.for Object.new }
        expect(&result).to raise_error(Gemsmith::Errors::RequirementConversion)
      end
    end
  end

  describe "#initialize" do
    context "with valid operators" do
      it "does not fail with error" do
        described_class.operators.each do |operator|
          result = -> { described_class.new operator: operator }
          expect(&result).not_to raise_error
        end
      end
    end

    context "with invalid operator" do
      it "fails with requirement operator error" do
        result = -> { described_class.new operator: "bogus" }
        message = "Invalid gem requirement operator. Use: >, >=, =, !=, <, <=, ~>."

        expect(&result).to raise_error(Gemsmith::Errors::RequirementOperator, message)
      end
    end
  end

  describe "#operator" do
    context "with default settings" do
      it "answers default operator" do
        expect(requirement.operator).to eq(">=")
      end
    end

    context "with custom settings" do
      subject(:requirement) { described_class.new operator: operator }

      let(:operator) { "~>" }

      it "answers custom operator" do
        expect(requirement.operator).to eq(operator)
      end
    end
  end

  describe "#raw_version" do
    context "with default settings" do
      it "answers default version string" do
        expect(requirement.raw_version).to eq("0")
      end
    end

    context "with custom settings" do
      subject(:requirement) { described_class.new raw_version: raw_version }

      let(:raw_version) { "1.2" }

      it "answrs custom version string" do
        expect(requirement.raw_version).to eq(raw_version)
      end
    end
  end

  describe "#version" do
    context "with default settings" do
      it "answers default version" do
        expect(requirement.version).to eq(Versionaire::Version.new)
      end
    end

    context "with custom settings" do
      subject(:requirement) { described_class.new raw_version: "1.2" }

      let(:version) { Versionaire::Version "1.2.0" }

      it "answers custom version" do
        expect(requirement.version).to eq(version)
      end
    end
  end

  describe "#version_segments" do
    context "with default settings" do
      it "answers array of default version segments" do
        expect(requirement.version_segments).to contain_exactly(0)
      end
    end

    context "with custom settings" do
      subject(:requirement) { described_class.new raw_version: "1.2.3" }

      it "answers array of custom version segments" do
        expect(requirement.version_segments).to contain_exactly(1, 2, 3)
      end
    end
  end

  describe "#to_s" do
    context "with default settings" do
      it "answers default string representation" do
        expect(requirement.to_s).to eq(">= 0.0.0")
      end
    end

    context "with custom settings" do
      subject(:requirement) { described_class.new raw_version: "1.2.3" }

      it "answers custom string representation" do
        expect(requirement.to_s).to eq(">= 1.2.3")
      end
    end
  end
end
