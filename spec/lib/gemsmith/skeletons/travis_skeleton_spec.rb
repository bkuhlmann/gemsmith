require "spec_helper"

RSpec.describe Gemsmith::Skeletons::TravisSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { instance_spy Gemsmith::Configuration, gem_name: "tester", create_travis?: create_travis }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:create_travis) { true }

      it "creates Travis CI config" do
        expect(cli).to have_received(:template).with("%gem_name%/.travis.yml.tt", configuration.to_h)
      end
    end

    context "when disabled" do
      let(:create_travis) { false }

      it "does not create Travis CI config" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
