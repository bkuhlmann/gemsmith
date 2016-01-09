require "spec_helper"

RSpec.describe Gemsmith::Skeletons::CLISkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { instance_spy Gemsmith::Configuration, gem_name: "tester", create_cli?: create_cli }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:create_cli) { true }

      it "creates gem binary" do
        expect(cli).to have_received(:template).with("%gem_name%/bin/%gem_name%.tt", configuration.to_h)
      end

      it "creates command line interface" do
        expect(cli).to have_received(:template).with("%gem_name%/lib/%gem_name%/cli.rb.tt", configuration.to_h)
      end
    end

    context "when disabled" do
      let(:create_cli) { false }

      it "does not create files" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
