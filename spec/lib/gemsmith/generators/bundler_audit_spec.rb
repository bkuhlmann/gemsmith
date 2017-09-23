# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::BundlerAudit, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {bundler_audit: add_bundler_audit}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#run" do
    before { subject.run }

    context "when enabled" do
      let(:add_bundler_audit) { true }

      it "enables Rakefile Bundler Audit support" do
        expect(cli).to have_received(:uncomment_lines).with(
          "tester/Rakefile",
          %r(require.+bundler\/audit.+)
        )
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /Bundler\:\:Audit.+/)
      end
    end

    context "when disabled" do
      let(:add_bundler_audit) { false }

      it "does not uncomment lines" do
        expect(cli).to_not have_received(:uncomment_lines)
      end
    end
  end
end
