# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Reek, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {reek: create_reek}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:create_reek) { true }

      it "creates Rake file" do
        template = "%gem_name%/lib/tasks/reek.rake.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end
    end

    context "when disabled" do
      let(:create_reek) { false }

      it "does not create configuration file" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
