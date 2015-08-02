require "spec_helper"

describe Gemsmith::Skeletons::GitSkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name }
  subject { described_class.new cli }

  before do
    FileUtils.mkdir(gem_dir)
    allow(subject).to receive(:`)
  end

  describe "#create_files" do
    before { subject.create_files }

    it "initializes Git repository" do
      expect(subject).to have_received(:`).with("git init")
    end

    it "adds all skeleton files" do
      expect(subject).to have_received(:`).with("git add .")
    end

    it "creates initial commit" do
      expect(subject).to have_received(:`).with(%(git commit -a -n -m "Added Gemsmith skeleton."))
    end
  end
end
