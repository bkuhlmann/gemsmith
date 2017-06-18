# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Gem::ModuleFormatter do
  let(:name) { "Example" }

  let :content do
    "  def example_1\n" \
    "    1\n" \
    "  end\n\n" \
    "  def example_2\n" \
    "    2\n" \
    "  end\n"
  end

  subject { described_class.new name }

  describe ".indent" do
    it "answers default indentation" do
      expect(described_class.indent).to eq("")
    end

    it "answers custom indentation" do
      expect(described_class.indent(3)).to eq("      ")
    end
  end

  describe "#render" do
    context "with single module" do
      it "renders single module" do
        text = "module Example\n" \
               "  def example_1\n" \
               "    1\n" \
               "  end\n\n" \
               "  def example_2\n" \
               "    2\n" \
               "  end\n" \
               "end"

        expect(subject.render(content)).to eq(text)
      end
    end

    context "with multiple modules" do
      let(:name) { "One::Two::Three" }

      it "renders nested modules" do
        text = "module One\n" \
               "  module Two\n" \
               "    module Three\n" \
               "      def example_1\n" \
               "        1\n" \
               "      end\n\n" \
               "      def example_2\n" \
               "        2\n" \
               "      end\n" \
               "    end\n" \
               "  end\n" \
               "end"

        expect(subject.render(content)).to eq(text)
      end
    end

    context "with leading carriage return for content" do
      let :content do
        "\n  def example_1\n" \
        "    1\n" \
        "  end\n\n" \
        "  def example_2\n" \
        "    2\n" \
        "  end\n"
      end

      it "removes carriage return" do
        text = "module Example\n" \
               "  def example_1\n" \
               "    1\n" \
               "  end\n\n" \
               "  def example_2\n" \
               "    2\n" \
               "  end\n" \
               "end"

        expect(subject.render(content)).to eq(text)
      end
    end
  end
end
