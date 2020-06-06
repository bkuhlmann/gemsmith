# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::BundlerAudit, :temp_dir do
  subject(:bundler_audit) { described_class.new cli, configuration: configuration }

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {bundler_audit: add_bundler_audit}} }

  describe "#run" do
    before { bundler_audit.run }

    context "when enabled" do
      let(:add_bundler_audit) { true }

      it "uncomments Rakefile requirement" do
        expect(cli).to have_received(:uncomment_lines).with(
          "tester/Rakefile",
          %r(require.+bundler/audit.+)
        )
      end

      it "uncomments Rakefile execution" do
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /Bundler::Audit.+/)
      end
    end

    context "when disabled" do
      let(:add_bundler_audit) { false }

      it "does not uncomment lines" do
        expect(cli).not_to have_received(:uncomment_lines)
      end
    end
  end
end
