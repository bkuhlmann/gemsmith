require "spec_helper"

describe Gemsmith::Skeletons::PrySkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:options) { {} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name, template_options: options }
  subject { described_class.new cli }
  before { FileUtils.mkdir gem_dir }

  it_behaves_like "an optional skeleton", :pry

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:options) { {pry: true} }

      it "creates RSpec Pry extension" do
        expect(cli).to have_received(:template).with("%gem_name%/spec/support/extensions/pry.rb.tt", options)
      end
    end

    context "when disabled" do
      let(:options) { {pry: false} }

      it "does not create RSpec Pry extension" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
