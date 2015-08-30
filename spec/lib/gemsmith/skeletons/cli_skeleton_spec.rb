require "spec_helper"

describe Gemsmith::Skeletons::CLISkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:options) { {} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name, template_options: options }
  subject { described_class.new cli }
  before { FileUtils.mkdir gem_dir }

  it_behaves_like "an optional skeleton", :bin

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:options) { {bin: true} }

      it "creates gem binary" do
        expect(cli).to have_received(:template).with("%gem_name%/bin/%gem_name%.tt", options)
      end

      it "creates command line interface" do
        expect(cli).to have_received(:template).with("%gem_name%/lib/%gem_name%/cli.rb.tt", options)
      end
    end

    context "when disabled" do
      let(:options) { {bin: false} }

      it "creates gem binary" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
