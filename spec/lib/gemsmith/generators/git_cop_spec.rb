# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::GitCop, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {git_cop: create_git_cop}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#run" do
    before { subject.run }

    context "when enabled" do
      let(:create_git_cop) { true }

      it "enables Rakefile Git Cop support" do
        expect(cli).to have_received(:uncomment_lines).with(
          "tester/Rakefile",
          %r(require.+git\/cop.+)
        )
      end
    end

    context "when disabled" do
      let(:create_git_cop) { false }

      it "does not uncomment lines" do
        expect(cli).to_not have_received(:uncomment_lines)
      end
    end
  end
end
