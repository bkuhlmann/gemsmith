require "spec_helper"

describe Gemsmith::Skeletons::CLISkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:options) { {} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name, template_options: options }
  subject { described_class.new cli }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
    before { subject.create }

    it "creates gem binary" do
      expect(cli).to have_received(:template).with("%gem_name%/bin/%gem_name%.tt", options)
    end

    it "creates command line interface" do
      expect(cli).to have_received(:template).with("%gem_name%/lib/%gem_name%/cli.rb.tt", options)
    end
  end
end
