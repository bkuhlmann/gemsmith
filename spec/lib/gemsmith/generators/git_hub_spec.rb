# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::GitHub, :temp_dir do
  subject(:git_hub) { described_class.new cli, configuration: configuration }

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {git_hub: create_git_hub}} }

  describe "#run" do
    before { git_hub.run }

    context "when enabled" do
      let(:create_git_hub) { true }

      it "creates issues template" do
        expect(cli).to have_received(:template).with(
          "%gem_name%/.github/ISSUE_TEMPLATE.md.tt",
          configuration
        )
      end

      it "creates pull request template" do
        template = "%gem_name%/.github/PULL_REQUEST_TEMPLATE.md.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end
    end

    context "when disabled" do
      let(:create_git_hub) { false }

      it "does not create issue or pull request templates" do
        expect(cli).not_to have_received(:template)
      end
    end
  end
end
