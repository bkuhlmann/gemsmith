# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Reek do
  subject(:reek) { described_class.new cli, configuration: configuration }

  include_context "with temporary directory"

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {reek: create_reek}} }

  describe "#run" do
    before { reek.run }

    context "when enabled" do
      let(:create_reek) { true }

      it "does not remove Rakefile lines" do
        expect(cli).not_to have_received(:gsub_file)
      end

      it "creates configuration file" do
        expect(cli).to have_received(:template).with("%gem_name%/.reek.yml.tt", configuration)
      end
    end

    context "when disabled" do
      let(:create_reek) { false }

      it "removes Rakefile requirement" do
        expect(cli).to have_received(:gsub_file).with("tester/Rakefile", /require.+reek.+\n/, "")
      end

      it "removes Rakefile task" do
        expect(cli).to have_received(:gsub_file).with("tester/Rakefile", /Reek.+\n/, "")
      end

      it "does not create configuration file" do
        expect(cli).not_to have_received(:template)
      end
    end
  end
end
