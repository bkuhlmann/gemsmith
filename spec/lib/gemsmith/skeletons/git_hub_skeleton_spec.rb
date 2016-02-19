# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::GitHubSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { instance_spy Gemsmith::Configuration, gem_name: "tester", create_git_hub?: create_git_hub }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:create_git_hub) { true }

      it "creates issues template" do
        expect(cli).to have_received(:template).with("%gem_name%/.github/ISSUE_TEMPLATE.md.tt", configuration.to_h)
      end

      it "creates pull request template" do
        template = "%gem_name%/.github/PULL_REQUEST_TEMPLATE.md.tt"
        expect(cli).to have_received(:template).with(template, configuration.to_h)
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
