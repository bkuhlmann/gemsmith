# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Reek, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {reek: create_reek}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#run" do
    before { subject.run }

    context "when enabled" do
      let(:create_reek) { true }

      it "enables Rakefile Reek support" do
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /require.+reek.+/)
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /Reek.+/)
      end
    end

    context "when disabled" do
      let(:create_reek) { false }

      it "does not uncomment lines" do
        expect(cli).to_not have_received(:uncomment_lines)
      end
    end
  end
end
