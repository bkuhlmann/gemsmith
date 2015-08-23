require "spec_helper"

describe Gemsmith::Skeletons::RakeSkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:rakefile) { File.join temp_dir, gem_name, "Rakefile" }
  let(:options) { {} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name, template_options: options }
  subject { described_class.new cli }

  before { FileUtils.mkdir gem_dir }

  describe "#create_files" do
    before { subject.create_files }

    it "creates Rakefile" do
      expect(cli).to have_received(:template).with("%gem_name%/Rakefile.tt", options)
    end

    context "when RSpec is enabled" do
      let(:options) { {rspec: true} }

      it "adds RSpec to default tasks" do
        expect(cli).to have_received(:append_to_file).with("%gem_name%/Rakefile", "\ntask default: %w(spec)\n")
      end
    end

    context "when Rubocop is enabled" do
      let(:options) { {rubocop: true} }

      it "adds Rubocop to default tasks" do
        expect(cli).to have_received(:append_to_file).with("%gem_name%/Rakefile", "\ntask default: %w(rubocop)\n")
      end
    end

    context "when all options are enabled" do
      let(:options) { described_class.allowed_options.keys.reduce({}) { |hash, key| hash.merge key => true } }

      it "adds all tasks" do
        expect(cli).to have_received(:append_to_file).with("%gem_name%/Rakefile", "\ntask default: %w(spec rubocop)\n")
      end
    end

    context "when no options are supplied" do
      it "does not add default tasks" do
        expect(cli).to_not have_received(:append_to_file)
      end
    end
  end
end
