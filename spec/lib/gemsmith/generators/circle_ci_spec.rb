# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::CircleCI, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {circle_ci: create_circle_ci}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#run" do
    before { subject.run }

    context "when enabled" do
      let(:create_circle_ci) { true }

      it "creates Circle CI config" do
        expect(cli).to have_received(:template).with("%gem_name%/circle.yml.tt", configuration)
      end
    end

    context "when disabled" do
      let(:create_circle_ci) { false }

      it "does not create Circle CI config" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
