# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::TravisSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {travis: create_travis}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#create" do
    before { subject.create }

    context "when enabled" do
      let(:create_travis) { true }

      it "creates Travis CI config" do
        expect(cli).to have_received(:template).with("%gem_name%/.travis.yml.tt", configuration)
      end
    end

    context "when disabled" do
      let(:create_travis) { false }

      it "does not create Travis CI config" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
