require "spec_helper"

describe Gemsmith::Skeletons::BundlerSkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name }
  subject { described_class.new cli }

  before do
    FileUtils.mkdir(gem_dir)
    allow(subject).to receive(:`)
  end

  describe "#create_gemfile_lock" do
    before { subject.create_gemfile_lock }

    it "prints info about installing gem dependencies" do
      expect(cli).to have_received(:info).with("Installing gem dependencies...")
    end

    it "builds Gemfile.lock" do
      expect(subject).to have_received(:`).with("bundle install")
    end
  end
end
