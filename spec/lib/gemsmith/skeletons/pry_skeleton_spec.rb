require "spec_helper"

RSpec.describe Gemsmith::Skeletons::PrySkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { instance_spy Gemsmith::Configuration, gem_name: "tester", create_pry?: create_pry }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:create_pry) { true }

      it "creates RSpec Pry extension" do
        expect(cli).to have_received(:template).with("%gem_name%/spec/support/extensions/pry.rb.tt", configuration.to_h)
      end
    end

    context "when disabled" do
      let(:create_pry) { false }

      it "does not create RSpec Pry extension" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
