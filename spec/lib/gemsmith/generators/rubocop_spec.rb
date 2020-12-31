# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Rubocop do
  subject(:rubocop) { described_class.new cli, configuration: configuration }

  include_context "with temporary directory"

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {rubocop: create_rubocop}} }

  describe "#run" do
    before { rubocop.run }

    context "when enabled" do
      let(:create_rubocop) { true }

      it "does not remove Rakefile lines" do
        expect(cli).not_to have_received(:gsub_file)
      end

      it "creates configuration file" do
        expect(cli).to have_received(:template).with("%gem_name%/.rubocop.yml.tt", configuration)
      end

      it "runs rubocop" do
        expect(cli).to have_received(:run).with(
          "cd tester && bundle exec rubocop --auto-correct > /dev/null"
        )
      end
    end

    context "when disabled" do
      let(:create_rubocop) { false }

      it "removes Rakefile requirement" do
        expect(cli).to have_received(:gsub_file).with("tester/Rakefile", /require.+rubocop.+\n/, "")
      end

      it "removes Rakefile task" do
        expect(cli).to have_received(:gsub_file).with("tester/Rakefile", /RuboCop.+\n/, "")
      end

      it "does not create configuration file" do
        expect(cli).not_to have_received(:template)
      end

      it "does run rubocop autocorrect" do
        expect(cli).not_to have_received(:run)
      end
    end
  end
end
