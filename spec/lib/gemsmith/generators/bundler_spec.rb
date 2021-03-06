# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Bundler do
  subject(:bundler) { described_class.new cli, configuration: configuration }

  include_context "with temporary directory"

  using Refinements::Pathnames

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}} }
  let(:gem_root) { temp_dir.join "tester" }

  describe "#run" do
    before do
      gem_root.make_path
      bundler.run
    end

    it "prints gem dependencies are being installed" do
      expect(cli).to have_received(:say_status).with(
        :info,
        "Installing gem dependencies...",
        :green
      )
    end

    it "creates Gemfile.lock" do
      expect(cli).to have_received(:run).with("bundle install")
    end
  end
end
