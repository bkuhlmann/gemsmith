require "spec_helper"
require "gemsmith/rake/build"

describe Gemsmith::Rake::Build, :temp_dir do
  let(:tocer_class) { class_spy Tocer::Writer }
  let(:tocer) { instance_spy Tocer::Writer }
  subject { described_class.new tocer: tocer_class }

  describe "#doc" do
    let(:readme) { File.join Dir.pwd, "README.md" }
    before { allow(tocer_class).to receive(:new).with(readme).and_return(tocer) }

    it "updates README table of contents" do
      subject.doc
      expect(tocer).to have_received(:write)
    end

    it "prints status message" do
      result = -> { subject.doc }
      expect(&result).to output("Updated gem documentation.\n").to_stdout
    end
  end

  describe "#clean!" do
    let(:package_dir) { File.join temp_dir, "pkg" }
    let(:gem_file) { File.join package_dir, "test-0.1.0.gem" }

    before do
      FileUtils.mkdir_p package_dir
      FileUtils.touch gem_file
    end

    it "removes previously built gem artifacts" do
      Dir.chdir(temp_dir) { subject.clean! }
      expect(File.exist?(gem_file)).to eq(false)
    end

    it "prints status message" do
      result = -> { Dir.chdir(temp_dir) { subject.clean! } }
      expect(&result).to output("Gem artifacts cleaned.\n").to_stdout
    end
  end
end
