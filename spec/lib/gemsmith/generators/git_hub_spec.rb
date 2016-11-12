# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::GitHub, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {git_hub: create_git_hub}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#run" do
    before { subject.run }

    context "when enabled" do
      let(:create_git_hub) { true }

      it "creates issues template" do
        expect(cli).to have_received(:template).with("%gem_name%/.github/ISSUE_TEMPLATE.md.tt", configuration)
      end

      it "creates pull request template" do
        template = "%gem_name%/.github/PULL_REQUEST_TEMPLATE.md.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end
    end

    context "when disabled" do
      let(:create_git_hub) { false }

      it "creates issues template" do
        expect(cli).to_not have_received(:template)
      end

      it "creates pull request template" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
