# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::RakeSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:create_rspec) { false }
  let(:create_reek) { false }
  let(:create_rubocop) { false }
  let :configuration do
    {
      gem: {
        name: "tester"
      },
      create: {
        rspec: create_rspec,
        reek: create_reek,
        rubocop: create_rubocop
      }
    }
  end
  let(:rakefile) { File.join temp_dir, "Rakefile" }
  subject { described_class.new cli, configuration: configuration }

  describe "#create" do
    before { subject.create }

    it "creates Rakefile" do
      expect(cli).to have_received(:template).with("%gem_name%/Rakefile.tt", configuration)
    end

    context "when only RSpec is enabled" do
      let(:create_rspec) { true }

      it "adds RSpec to default tasks" do
        expect(cli).to have_received(:append_to_file).with("%gem_name%/Rakefile", "\ntask default: %w[spec]\n")
      end
    end

    context "when only Reek is enabled" do
      let(:create_reek) { true }

      it "adds Reek to default tasks" do
        expect(cli).to have_received(:append_to_file).with("%gem_name%/Rakefile", "\ntask default: %w[reek]\n")
      end
    end

    context "when only Rubocop is enabled" do
      let(:create_rubocop) { true }

      it "adds Rubocop to default tasks" do
        expect(cli).to have_received(:append_to_file).with("%gem_name%/Rakefile", "\ntask default: %w[rubocop]\n")
      end
    end

    context "when RSpec, Reek, and Rubocop are enabled" do
      let(:create_rspec) { true }
      let(:create_reek) { true }
      let(:create_rubocop) { true }

      it "adds all tasks" do
        expect(cli).to have_received(:append_to_file).with(
          "%gem_name%/Rakefile",
          "\ntask default: %w[spec reek rubocop]\n"
        )
      end
    end

    context "when no options are supplied" do
      it "does not add default tasks" do
        expect(cli).to_not have_received(:append_to_file)
      end
    end
  end
end
