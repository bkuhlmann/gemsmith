require "spec_helper"
require "gemsmith/rake/build"

describe Gemsmith::Rake::Build, :temp_dir do
  let(:tocer_class) { class_spy Tocer::Writer }
  let(:tocer) { instance_spy Tocer::Writer }
  let(:kernel) { class_spy Kernel }
  subject { described_class.new tocer: tocer_class, kernel: kernel }

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

  describe "#table_of_contents" do
    let(:doctoc_install) { "command -v doctoc > /dev/null" }
    let(:doctoc_command) { %(doctoc --title "# Table of Contents" README.md) }

    context "when DocToc is installed" do
      it "detects DocToc is installed" do
        subject.table_of_contents
        expect(kernel).to have_received(:system).with(doctoc_install)
      end

      it "updates table of contents" do
        subject.table_of_contents
        expect(kernel).to have_received(:system).with(doctoc_command)
      end
    end

    context "when DocToc is not installed" do
      before { allow(kernel).to receive(:system).with(doctoc_install).and_return(false) }

      it "does not update table of contents" do
        subject.table_of_contents
        expect(kernel).to_not have_received(:system).with(doctoc_command)
      end

      it "prints error message" do
        error = -> { subject.table_of_contents }
        url = "https://github.com/thlorenz/doctoc"
        command = "npm install --global doctoc"
        message = "Unable to update README Table of Contents, please install DocToc (#{url}): #{command}.\n"

        expect(&error).to output(message).to_stdout
      end

      it "exits as an error" do
        subject.table_of_contents
        expect(kernel).to have_received(:exit).with(1)
      end
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
