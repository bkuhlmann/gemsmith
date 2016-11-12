# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::CLISkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {cli: create_cli}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:create_cli) { true }

      it "creates gem binary" do
        expect(cli).to have_received(:template).with("%gem_name%/bin/%gem_name%.tt", configuration)
      end

      it "creates command line interface" do
        expect(cli).to have_received(:template).with("%gem_name%/lib/%gem_path%/cli.rb.tt", configuration)
      end

      it "creates command line interface spec" do
        template = "%gem_name%/spec/lib/%gem_path%/cli_spec.rb.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end

      it "sets excecutable file permission for setup script" do
        expect(cli).to have_received(:chmod).with("tester/bin/tester", 0o755)
      end
    end

    context "when disabled" do
      let(:create_cli) { false }

      it "does not create files" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
