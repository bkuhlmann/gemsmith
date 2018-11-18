# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::CodeClimate, :temp_dir do
  subject(:code_climate) { described_class.new cli, configuration: configuration }

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {code_climate: create_code_climate}} }

  describe "#run" do
    before { code_climate.run }

    context "when enabled" do
      let(:create_code_climate) { true }

      it "creates configuration file" do
        expect(cli).to have_received(:template).with(
          "%gem_name%/.codeclimate.yml.tt",
          configuration
        )
      end
    end

    context "when disabled" do
      let(:create_code_climate) { false }

      it "does not create configuration file" do
        expect(cli).not_to have_received(:template)
      end
    end
  end
end
