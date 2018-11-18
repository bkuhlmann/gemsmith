# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Reek, :temp_dir do
  subject(:reek) { described_class.new cli, configuration: configuration }

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {reek: create_reek}} }

  describe "#run" do
    before { reek.run }

    context "when enabled" do
      let(:create_reek) { true }

      it "uncomments Rakefile" do
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /require.+reek.+/)
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /Reek.+/)
      end

      it "creates configuration file" do
        expect(cli).to have_received(:template).with("%gem_name%/.reek.yml.tt", configuration)
      end
    end

    context "when disabled" do
      let(:create_reek) { false }

      it "does not uncomment Rakefile" do
        expect(cli).not_to have_received(:uncomment_lines)
      end

      it "does not create configuration file" do
        expect(cli).not_to have_received(:template)
      end
    end
  end
end
