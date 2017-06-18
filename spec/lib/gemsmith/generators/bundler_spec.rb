# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Bundler, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}} }
  let(:gem_root) { File.join temp_dir, "tester" }
  subject { described_class.new cli, configuration: configuration }
  before do
    FileUtils.mkdir_p gem_root
    allow(subject).to receive(:`)
  end

  describe "#run" do
    before { subject.run }

    it "prints gem dependencies are being installed" do
      expect(cli).to have_received(:say_status).with(
        :info,
        "Installing gem dependencies...",
        :green
      )
    end

    it "creates Gemfile.lock" do
      expect(subject).to have_received(:`).with("bundle install")
    end
  end
end
