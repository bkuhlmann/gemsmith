require "spec_helper"
require "gemsmith/rake/release"

describe Gemsmith::Rake::Release, :temp_dir do
  let(:gem_spec_path) { File.join File.dirname(__FILE__), "..", "..", "..", "support", "fixtures", "tester.gemspec" }
  let(:kernel) { class_spy Kernel }
  subject { described_class.new gem_spec_path, kernel: kernel }

  describe "#initialize" do
    context "when using default gem spec path" do
      it "loads gemspec" do
        subject = described_class.new
        expect(subject.name).to eq("gemsmith")
      end
    end

    context "when using default gem spec path in invalid directory" do
      it "prints gemspec file path error" do
        Dir.chdir(temp_dir) do
          result = -> { described_class.new }
          expect(&result).to output("Invalid gemspec file path: .\n").to_stdout
        end
      end
    end

    context "when using custom gem spec path" do
      it "loads gemspec" do
        subject = described_class.new gem_spec_path
        expect(subject.name).to eq("tester")
      end
    end

    context "when using invalid gem spec path" do
      it "prints gemspec file path error" do
        result = -> { described_class.new "bogus" }
        expect(&result).to output("Invalid gemspec file path: bogus.\n").to_stdout
      end
    end
  end

  describe "#name" do
    it "answers gem name" do
      expect(subject.name).to eq("tester")
    end
  end

  describe "#version" do
    it "answers current version" do
      expect(subject.version).to eq("0.1.0")
    end
  end

  describe "#version_formatted" do
    it "answers current, formatted, version" do
      expect(subject.version_formatted).to eq("v0.1.0")
    end
  end

  describe "#package_file_name" do
    it "answers versioned gem package file name" do
      expect((subject.package_file_name)).to eq("tester-0.1.0.gem")
    end
  end

  describe "#tag" do
    let(:command) { %(git tag --sign --annotate "v0.1.0" --message "Version 0.1.0.") }

    context "when tag doesn't exist" do
      before do
        allow(kernel).to receive(:system).with("git show v0.1.0").and_return(false)
        allow(kernel).to receive(:system).with(command).and_return(true)
      end

      context "when tag creation succeeds" do
        it "tags gem", :aggregate_failures do
          subject.tag

          expect(kernel).to have_received(:system).with("git show v0.1.0")
          expect(kernel).to have_received(:system).with(command)
        end
      end

      context "when tag creation fails" do
        before do
          allow(kernel).to receive(:system).with(command).and_return(false)
          allow(kernel).to receive(:system).with("git tag -d v0.1.0")
        end

        it "removes tag" do
          subject.tag
          expect(kernel).to have_received(:system).with("git tag -d v0.1.0")
        end

        it "prints error message" do
          result = -> { subject.tag }
          expect(&result).to output(%(Removed "v0.1.0" due to errors.\n)).to_stdout
        end
      end
    end

    context "when tag exists" do
      before { allow(kernel).to receive(:system).with("git show v0.1.0").and_return(true) }

      it "does not tag gem" do
        subject.tag
        expect(kernel).to_not have_received(:system).with(command)
      end

      it "prints error message" do
        result = -> { subject.tag }
        expect(&result).to output("Tag v0.1.0 exists!\n").to_stdout
      end
    end
  end

  describe "#push" do
    it "pushes tags" do
      subject.push
      expect(kernel).to have_received(:system).with("git push --tags")
    end
  end
end
