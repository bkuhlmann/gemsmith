# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::GitLint do
  subject(:git_lint) { described_class.new cli, configuration: configuration }

  include_context "with temporary directory"

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, generate: {git_lint: create_git_lint}} }

  describe "#run" do
    before { git_lint.run }

    context "when enabled" do
      let(:create_git_lint) { true }

      it "does not remove Rakefile lines" do
        expect(cli).not_to have_received(:gsub_file)
      end
    end

    context "when disabled" do
      let(:create_git_lint) { false }

      it "removes Rakefile requirement" do
        expect(cli).to have_received(:gsub_file).with(
          "tester/Rakefile",
          %r(require.+git/lint.+\n),
          ""
        )
      end
    end
  end
end
