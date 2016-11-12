# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::SCSSLint, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {scss_lint: create_scss_lint}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:create_scss_lint) { true }

      it "creates Rake file" do
        template = "%gem_name%/lib/tasks/scss_lint.rake.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end
    end

    context "when disabled" do
      let(:create_scss_lint) { false }

      it "does not create configuration file" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
