# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Gems::Picker do
  subject(:picker) { described_class.new finder:, kernel: }

  let(:kernel) { class_spy Kernel }
  let(:finder) { instance_double Gemsmith::Gems::Finder }
  let(:fixture_path) { Bundler.root.join "spec/support/fixtures/gemsmith-test.gemspec" }
  let(:specification) { Gemsmith::Gems::Loader.call fixture_path }

  before { allow(finder).to receive(:call).and_return([specification]) }

  describe ".call" do
    it "answers specification" do
      result = described_class.call("logger", finder:, kernel:)
      expect(result.success).to eq(specification)
    end
  end

  describe "#initialize" do
    it "prints deprecation warning" do
      expectation = proc { picker.call "test" }
      expect(&expectation).to output(/DEPRECATION/).to_stderr
    end
  end

  describe "#call" do
    it "answers computed specification with single selection" do
      result = picker.call "logger"
      expect(result.success).to eq(specification)
    end

    context "with multiple selections" do
      before do
        allow(finder).to receive(:call).and_return([specification, specification_b])
        allow(kernel).to receive(:gets).and_return("2")
      end

      let(:specification_b) { Gemsmith::Gems::Loader.call fixture_path }

      it "answers chosen specification" do
        result = picker.call "logger"
        expect(result.success).to eq(specification_b)
      end
    end

    context "with zero selections" do
      before { allow(finder).to receive(:call).and_return([]) }

      it "fails with message" do
        result = picker.call "test"
        expect(result.failure).to eq("Unknown gem or gem is not installed: test.")
      end
    end
  end
end
