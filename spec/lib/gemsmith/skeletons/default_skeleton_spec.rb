require "spec_helper"

describe Gemsmith::Skeletons::DefaultSkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:options) { {} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name, template_options: options }
  subject { described_class.new cli }

  before { FileUtils.mkdir gem_dir }

  describe "#create_files" do
    before { subject.create_files }

    it "creates Gemfile" do
      expect(cli).to have_received(:template).with("%gem_name%/Gemfile.tt", options)
    end

    it "creates gem spec" do
      expect(cli).to have_received(:template).with("%gem_name%/%gem_name%.gemspec.tt", options)
    end

    it "creates gem library" do
      expect(cli).to have_received(:template).with("%gem_name%/lib/%gem_name%.rb.tt", options)
    end

    it "creates gem identity" do
      expect(cli).to have_received(:template).with("%gem_name%/lib/%gem_name%/identity.rb.tt", options)
    end
  end
end
