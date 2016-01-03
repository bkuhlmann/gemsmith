require "spec_helper"

describe Gemsmith::Skeletons::RakeSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:create_rspec) { false }
  let(:create_rubocop) { false }
  let(:config_options) { {gem_name: "tester", create_rspec?: create_rspec, create_rubocop?: create_rubocop} }
  let(:configuration) { instance_spy Gemsmith::Configuration, config_options }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  let(:rakefile) { File.join temp_dir, gem_name, "Rakefile" }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }


  describe "#create_console_task" do
    before { subject.create_console_task }

    it "creates engine file" do
      expect(cli).to have_received(:template).with("%gem_name%/lib/tasks/console.rake.tt", configuration.to_h)
    end
  end

  describe "#create" do
    before do
      allow(subject).to receive(:create_console_task)
      subject.create
    end

    it "creates console task" do
      expect(subject).to have_received(:create_console_task)
    end

    it "creates Rakefile" do
      expect(cli).to have_received(:template).with("%gem_name%/Rakefile.tt", configuration.to_h)
    end

    context "when only RSpec is enabled" do
      let(:create_rspec) { true }

      it "adds RSpec to default tasks" do
        expect(cli).to have_received(:append_to_file).with("%gem_name%/Rakefile", "\ntask default: %w(spec)\n")
      end
    end

    context "when only Rubocop is enabled" do
      let(:create_rubocop) { true }

      it "adds Rubocop to default tasks" do
        expect(cli).to have_received(:append_to_file).with("%gem_name%/Rakefile", "\ntask default: %w(rubocop)\n")
      end
    end

    context "when RSpec and Rubocop is enabled" do
      let(:create_rspec) { true }
      let(:create_rubocop) { true }

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
