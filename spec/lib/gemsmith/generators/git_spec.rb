# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Git, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}} }
  let(:gem_dir) { File.join temp_dir, configuration.dig(:gem, :name) }
  subject { described_class.new cli, configuration: configuration }
  before do
    FileUtils.mkdir gem_dir
    allow(subject).to receive(:`)
  end

  describe "#create_ignore_file" do
    it "creates Git ignore file" do
      subject.create_ignore_file
      expect(cli).to have_received(:template).with("%gem_name%/.gitignore.tt", configuration)
    end
  end

  describe "#create_repository" do
    before { subject.create_repository }

    it "initializes Git repository" do
      expect(subject).to have_received(:`).with("git init")
    end

    it "adds generated files" do
      expect(subject).to have_received(:`).with("git add .")
    end

    it "creates initial commit" do
      commit_subject = "Added Gemsmith files."
      body = "Built with #{Gemsmith::Identity.version_label}."

      expect(subject).to have_received(:`).with(
        %(git commit --all --no-verify --message "#{commit_subject}" --message "#{body}")
      )
    end
  end

  describe "#run" do
    before do
      allow(subject).to receive(:create_ignore_file)
      allow(subject).to receive(:create_repository)
    end

    it "generates Git support", :aggregate_failures do
      subject.run

      expect(subject).to have_received(:create_ignore_file)
      expect(subject).to have_received(:create_repository)
    end
  end
end
