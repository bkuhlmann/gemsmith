# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Rubocop, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {rubocop: create_rubocop}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#run" do
    before { subject.run }

    context "when enabled" do
      let(:create_rubocop) { true }

      it "enables Rakefile Rubocop support" do
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /require.+rubocop.+/)
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /RuboCop.+/)
      end

      it "creates configuration file" do
        expect(cli).to have_received(:template).with("%gem_name%/.rubocop.yml.tt", configuration)
      end

      it "runs rubocop" do
        expect(cli).to have_received(:run).with("rubocop --auto-correct tester > /dev/null")
      end
    end

    context "when disabled" do
      let(:create_rubocop) { false }

      it "does not uncomment lines" do
        expect(cli).to_not have_received(:uncomment_lines)
      end

      it "does not create configuration file" do
        expect(cli).to_not have_received(:template)
      end

      it "does run rubocop autocorrect" do
        expect(cli).to_not have_received(:run)
      end
    end
  end
end
