require "spec_helper"

describe Gemsmith::Skeletons::TravisSkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:options) { {} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name, template_options: options }
  subject { described_class.new cli }
  before { FileUtils.mkdir gem_dir }

  it_behaves_like "an optional skeleton", :travis

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:options) { {travis: true} }

      it "creates Travic CI configuration" do
        expect(cli).to have_received(:template).with("%gem_name%/.travis.yml.tt", options)
      end
    end

    context "when disabled" do
      let(:options) { {travis: false} }

      it "creates Travic CI configuration" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
