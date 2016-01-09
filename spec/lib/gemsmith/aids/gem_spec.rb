require "spec_helper"

RSpec.describe Gemsmith::Aids::Gem do
  subject { described_class.new string }

  describe "#name" do
    context "with defaults" do
      subject { described_class.new }

      it "answers snake cased name" do
        expect(subject.name).to eq("unknown")
      end
    end

    context "with camel case" do
      let(:string) { "CamelCaseTest" }

      it "answers snake cased name" do
        expect(subject.name).to eq("camel_case_test")
      end
    end

    context "with spaces" do
      let(:string) { "Space Test" }

      it "answers snake cased name" do
        expect(subject.name).to eq("space_test")
      end
    end

    context "with hyphens (-)" do
      let(:string) { "Hyphen-Test" }

      it "answers snake cased name" do
        expect(subject.name).to eq("hyphen_test")
      end
    end
  end

  describe "#klass" do
    context "with defaults" do
      subject { described_class.new }

      it "answers camel cased class" do
        expect(subject.klass).to eq("Unknown")
      end
    end

    context "with camel case" do
      let(:string) { "CamelCaseTest" }

      it "answers camel cased class" do
        expect(subject.klass).to eq("CamelCaseTest")
      end
    end

    context "with spaces" do
      let(:string) { "Space Test" }

      it "answers camel cased class" do
        expect(subject.klass).to eq("SpaceTest")
      end
    end

    context "with hyphens (-)" do
      let(:string) { "Hyphen-Test" }

      it "answers camel cased class" do
        expect(subject.klass).to eq("HyphenTest")
      end
    end
  end
end
