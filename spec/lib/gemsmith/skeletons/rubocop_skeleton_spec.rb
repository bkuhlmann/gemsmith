require "spec_helper"

describe Gemsmith::Skeletons::RubocopSkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:options) { {} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name, template_options: options }
  subject { described_class.new cli }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
    before { subject.create }

    it "creates configuration file" do
      expect(cli).to have_received(:template).with("%gem_name%/.rubocop.yml.tt", options)
    end

    it "creates Rake file" do
      expect(cli).to have_received(:template).with("%gem_name%/lib/%gem_name%/tasks/rubocop.rake.tt", options)
    end
  end
end
