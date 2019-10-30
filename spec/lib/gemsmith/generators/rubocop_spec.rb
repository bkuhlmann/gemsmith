# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Rubocop, :temp_dir do
  subject(:rubocop) { described_class.new cli, configuration: configuration }

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {rubocop: create_rubocop}} }

  describe "#run" do
    before { rubocop.run }

    context "when enabled" do
      let(:create_rubocop) { true }

      it "uncomments Rakefile requirement" do
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /require.+rubocop.+/)
      end

      it "uncomments Rakefile execution" do
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /RuboCop.+/)
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

      it "does not uncomment lines" do
        expect(cli).not_to have_received(:uncomment_lines)
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
