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

  describe "#clean" do
    let(:package_dir) { File.join temp_dir, "pkg" }
    let(:gem_file) { File.join package_dir, "test-0.1.0.gem" }

    before do
      FileUtils.mkdir_p package_dir
      FileUtils.touch gem_file
    end

    it "removes previously built gem artifacts" do
      Dir.chdir(temp_dir) { subject.clean }
      expect(File.exist?(gem_file)).to eq(false)
    end

    it "prints status message" do
      result = -> { Dir.chdir(temp_dir) { subject.clean } }
      expect(&result).to output("Cleaned gem artifacts.\n").to_stdout
    end
  end

  describe "#validate" do
    before do
      Dir.chdir temp_dir do
        `git init`
        `git config --local user.name "Testy Tester"`
        `git config --local user.email "tester@example.com"`
        `rm -rf .git/hooks`
        `touch test.txt`
        `git add --all .`
        `git commit --all --message "Added test.txt."`
      end
    end
    context "with Git changes" do
      it "fails the build" do
        Dir.chdir temp_dir do
          `touch extra.txt`
          result = -> { subject.validate }

          expect(&result).to raise_error(StandardError, /Build failed: Gem has uncommitted changes./)
        end
      end
    end

    context "without Git changes" do
      it "passes the build" do
        Dir.chdir temp_dir do
          result = -> { subject.validate }
          expect(&result).to_not raise_error
        end
      end
    end
  end
end
