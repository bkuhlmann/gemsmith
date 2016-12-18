# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::SCSSLint, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {scss_lint: create_scss_lint}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#run" do
    before { subject.run }

    context "when enabled" do
      let(:create_scss_lint) { true }

      it "enables Rakefile SCSS Lint support" do
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /require.+scss.+/)
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /SCSSLint.+/)
      end
    end

    context "when disabled" do
      let(:create_scss_lint) { false }

      it "does not create configuration file" do
        expect(cli).to_not have_received(:uncomment_lines)
      end
    end
  end
end
