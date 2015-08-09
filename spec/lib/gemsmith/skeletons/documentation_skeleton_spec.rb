require "spec_helper"

describe Gemsmith::Skeletons::DocumentationSkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:options) { {} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name, template_options: options }
  subject { described_class.new cli }

  before { FileUtils.mkdir gem_dir }

  describe "#create_files" do
    before { subject.create_files }

    it "creates readme" do
      expect(cli).to have_received(:template).with("%gem_name%/README.md.tt", options)
    end

    it "creates contributing guidelines" do
      expect(cli).to have_received(:template).with("%gem_name%/CONTRIBUTING.md.tt", options)
    end

    it "creates code of conduct" do
      expect(cli).to have_received(:template).with("%gem_name%/CODE_OF_CONDUCT.md.tt", options)
    end

    it "creates software license" do
      expect(cli).to have_received(:template).with("%gem_name%/LICENSE.md.tt", options)
    end

    it "creates change log" do
      expect(cli).to have_received(:template).with("%gem_name%/CHANGELOG.md.tt", options)
    end
  end
end
