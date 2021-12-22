# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Tools::Installer do
  include Dry::Monads[:result]

  using Refinements::Pathnames

  subject(:installer) { described_class.new steps: }

  include_context "with application container"

  let(:cleaner) { instance_spy Gemsmith::Tools::Cleaner, call: Success() }

  describe "#call" do
    context "when success" do
      let(:steps) { [proc { Success() }, proc { Success() }] }

      it "installs gem" do
        installer.call specification

        expect(executor).to have_received(:capture3).with(
          "gem",
          "install",
          "tmp/gemsmith-tester-0.0.0.gem"
        )
      end

      it "answers specification" do
        result = installer.call specification
        expect(result.success).to eq(specification)
      end
    end

    context "when failure" do
      let(:steps) { [proc { Failure "Danger!" }, proc { Success() }] }

      it "answers failure" do
        result = installer.call specification
        expect(result.failure).to eq("Danger!")
      end
    end
  end
end
