# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::GuardSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { instance_spy Gemsmith::Configuration, gem_name: "tester", create_guard?: create_guard }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:create_guard) { true }

      it "creates Guardfile" do
        expect(cli).to have_received(:template).with("%gem_name%/Guardfile.tt", configuration.to_h)
      end
    end

    context "when disabled" do
      let(:create_guard) { false }

      it "does not create Guardfile" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
