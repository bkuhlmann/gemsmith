# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::RubocopSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { instance_spy Gemsmith::Configuration, gem_name: "tester", create_rubocop?: create_rubocop }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:create_rubocop) { true }

      it "creates configuration file" do
        expect(cli).to have_received(:template).with("%gem_name%/.rubocop.yml.tt", configuration.to_h)
      end

      it "creates Rake file" do
        template = "%gem_name%/lib/tasks/rubocop.rake.tt"
        expect(cli).to have_received(:template).with(template, configuration.to_h)
      end

      it "runs rubocop" do
        expect(cli).to have_received(:run).with("rubocop --auto-correct > /dev/null")
      end
    end

    context "when disabled" do
      let(:create_rubocop) { false }

      it "does not create configuration file" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
