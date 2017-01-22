# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Rake, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:generate_rspec) { false }
  let(:generate_reek) { false }
  let(:generate_rubocop) { false }
  let(:generate_scss_lint) { false }
  let :configuration do
    {
      gem: {
        name: "tester"
      },
      generate: {
        rspec: generate_rspec,
        reek: generate_reek,
        rubocop: generate_rubocop,
        scss_lint: generate_scss_lint
      }
    }
  end
  let(:rakefile) { File.join temp_dir, "Rakefile" }
  subject { described_class.new cli, configuration: configuration }

  describe "#run" do
    before { subject.run }

    it "creates Rakefile" do
      expect(cli).to have_received(:template).with("%gem_name%/Rakefile.tt", configuration)
    end

    context "when only RSpec is enabled" do
      let(:generate_rspec) { true }

      it "adds RSpec to default tasks" do
        expect(cli).to have_received(:append_to_file).with(
          "%gem_name%/Rakefile",
          "\ntask default: %w[spec]\n"
        )
      end
    end

    context "when only Reek is enabled" do
      let(:generate_reek) { true }

      it "adds Reek to default tasks" do
        expect(cli).to have_received(:append_to_file).with(
          "%gem_name%/Rakefile",
          "\ntask default: %w[reek]\n"
        )
      end
    end

    context "when only Rubocop is enabled" do
      let(:generate_rubocop) { true }

      it "adds Rubocop to default tasks" do
        expect(cli).to have_received(:append_to_file).with(
          "%gem_name%/Rakefile",
          "\ntask default: %w[rubocop]\n"
        )
      end
    end

    context "when only SCSS Lint is enabled" do
      let(:generate_scss_lint) { true }

      it "adds SCSS Lint to default tasks" do
        expect(cli).to have_received(:append_to_file).with(
          "%gem_name%/Rakefile",
          "\ntask default: %w[scss_lint]\n"
        )
      end
    end

    context "when RSpec, Reek, and Rubocop are enabled" do
      let(:generate_rspec) { true }
      let(:generate_reek) { true }
      let(:generate_rubocop) { true }
      let(:generate_scss_lint) { true }

      it "adds all tasks" do
        expect(cli).to have_received(:append_to_file).with(
          "%gem_name%/Rakefile",
          "\ntask default: %w[spec reek rubocop scss_lint]\n"
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
