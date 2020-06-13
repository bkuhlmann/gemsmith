# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::GitLint, :temp_dir do
  subject(:git_lint) { described_class.new cli, configuration: configuration }

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {git_lint: create_git_lint}} }

  describe "#run" do
    before { git_lint.run }

    context "when enabled" do
      let(:create_git_lint) { true }

      it "enables Rakefile Git Cop support" do
        expect(cli).to have_received(:uncomment_lines).with(
          "tester/Rakefile",
          %r(require.+git/lint.+)
        )
      end
    end

    context "when disabled" do
      let(:create_git_lint) { false }

      it "does not uncomment lines" do
        expect(cli).not_to have_received(:uncomment_lines)
      end
    end
  end
end
