# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Guard do
  subject(:guard) { described_class.new cli, configuration: configuration }

  include_context "with temporary directory"

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {guard: create_guard}} }

  describe "#run" do
    before { guard.run }

    context "when enabled" do
      let(:create_guard) { true }

      it "creates Guardfile" do
        expect(cli).to have_received(:template).with("%gem_name%/Guardfile.tt", configuration)
      end
    end

    context "when disabled" do
      let(:create_guard) { false }

      it "does not create Guardfile" do
        expect(cli).not_to have_received(:template)
      end
    end
  end
end
