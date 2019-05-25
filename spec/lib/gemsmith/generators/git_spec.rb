# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Git, :temp_dir do
  subject(:git) { described_class.new cli, configuration: configuration }

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}} }
  let(:gem_dir) { File.join temp_dir, configuration.dig(:gem, :name) }

  before do
    FileUtils.mkdir gem_dir

    # rubocop:disable RSpec/SubjectStub
    allow(git).to receive(:`)
    # rubocop:enable RSpec/SubjectStub
  end

  describe "#create_ignore_file" do
    it "creates Git ignore file" do
      git.create_ignore_file
      expect(cli).to have_received(:template).with("%gem_name%/.gitignore.tt", configuration)
    end
  end

  describe "#create_repository" do
    before { git.create_repository }

    it "initializes Git repository" do
      expect(git).to have_received(:`).with("git init")
    end

    it "adds generated files" do
      expect(git).to have_received(:`).with("git add .")
    end

    it "creates initial commit" do
      commit_subject = "Added gem skeleton."
      body = "Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith) " \
             "#{Gemsmith::Identity.version}."

      expect(git).to have_received(:`).with(
        %(git commit --all --no-verify --message "#{commit_subject}" --message "#{body}")
      )
    end
  end

  describe "#run" do
    before do
      # rubocop:disable RSpec/SubjectStub
      allow(git).to receive(:create_ignore_file)
      allow(git).to receive(:create_repository)
      # rubocop:enable RSpec/SubjectStub
    end

    it "generates Git support", :aggregate_failures do
      git.run

      expect(git).to have_received(:create_ignore_file)
      expect(git).to have_received(:create_repository)
    end
  end
end
