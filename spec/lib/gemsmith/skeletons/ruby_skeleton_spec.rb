require "spec_helper"

RSpec.describe Gemsmith::Skeletons::RubySkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { instance_spy Gemsmith::Configuration, gem_name: "tester" }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
    it "creates files" do
      subject.create
      expect(cli).to have_received(:template).with("%gem_name%/.ruby-version.tt", configuration.to_h)
    end
  end
end
