require "spec_helper"

describe Gemsmith::Skeletons::GitSkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:options) { {} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name, template_options: options }
  subject { described_class.new cli }

  before do
    FileUtils.mkdir(gem_dir)
    allow(subject).to receive(:`)
  end

  describe "#create_ignore_file" do
    it "creates Git ignore file" do
      subject.create_ignore_file
      expect(cli).to have_received(:template).with("%gem_name%/.gitignore.tt", options)
    end
  end

  describe "#create_repository" do
    before { subject.create_repository }

    it "initializes Git repository" do
      expect(subject).to have_received(:`).with("git init")
    end

    it "adds all skeleton files" do
      expect(subject).to have_received(:`).with("git add .")
    end

    it "creates initial commit" do
      expect(subject).to have_received(:`).with(%(git commit --all --no-verify --message "Added Gemsmith skeleton."))
    end
  end

  describe "#create" do
    before do
      allow(subject).to receive(:create_ignore_file)
      allow(subject).to receive(:create_repository)
    end

    it "creates skeleton", :aggregate_failures do
      subject.create

      expect(subject).to have_received(:create_ignore_file)
      expect(subject).to have_received(:create_repository)
    end
  end
end
