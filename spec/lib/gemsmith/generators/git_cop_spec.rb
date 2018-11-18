# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::GitCop, :temp_dir do
  subject(:git_cop) { described_class.new cli, configuration: configuration }

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {git_cop: create_git_cop}} }

  describe "#run" do
    before { git_cop.run }

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
        expect(cli).not_to have_received(:uncomment_lines)
      end
    end
  end
end
