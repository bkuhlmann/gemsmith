# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Tools::Installer do
  using Refinements::Pathname

  subject(:installer) { described_class.new steps: }

  include_context "with application dependencies"

  let(:cleaner) { instance_spy Gemsmith::Tools::Cleaner, call: Success() }

  describe "#call" do
    context "with success" do
      let(:steps) { [proc { Success() }, proc { Success() }] }

      it "installs gem" do
        installer.call specification

        expect(executor).to have_received(:capture3).with(
          "gem",
          "install",
          "tmp/gemsmith-test-0.0.0.gem"
        )
      end

      it "answers specification" do
        result = installer.call specification
        expect(result.success).to eq(specification)
      end
    end

    context "with step failure" do
      let(:steps) { [proc { Failure "Danger!" }, proc { Success() }] }

      it "answers failure" do
        result = installer.call specification
        expect(result.failure).to eq("Danger!")
      end
    end

    context "with install failure" do
      let(:steps) { [proc { Success() }] }

      it "answers failure" do
        status = instance_spy Process::Status, success?: false
        allow(executor).to receive(:capture3).and_return ["", "", status]

        result = installer.call specification
        expect(result.failure).to eq("Unable to install: tmp/gemsmith-test-0.0.0.gem.")
      end
    end
  end
end
