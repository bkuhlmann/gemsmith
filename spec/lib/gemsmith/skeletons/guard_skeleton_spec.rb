require "spec_helper"

describe Gemsmith::Skeletons::GuardSkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:options) { {} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name, template_options: options }
  subject { described_class.new cli }
  before { FileUtils.mkdir gem_dir }

  it_behaves_like "an optional skeleton", :guard

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:options) { {guard: true} }

      it "creates Guardfile" do
        expect(cli).to have_received(:template).with("%gem_name%/Guardfile.tt", options)
      end
    end

    context "when disabled" do
      let(:options) { {guard: false} }

      it "does not create Guardfile" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
