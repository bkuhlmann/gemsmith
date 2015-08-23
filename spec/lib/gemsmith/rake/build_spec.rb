require "spec_helper"
require "gemsmith/rake/build"

describe Gemsmith::Rake::Build, :temp_dir do
  let(:kernel) { class_spy Kernel }
  subject { described_class.new kernel: kernel }

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
