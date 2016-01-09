require "spec_helper"
require "gemsmith/rake/release"

RSpec.describe Gemsmith::Rake::Release, :temp_dir do
  let(:publisher) { instance_spy Milestoner::Publisher }
  let(:gem_spec_path) { File.join File.dirname(__FILE__), "..", "..", "..", "support", "fixtures", "tester.gemspec" }
  subject { described_class.new gem_spec_path, publisher: publisher }

  describe "#initialize" do
    context "when using default gem spec path" do
      it "loads gemspec" do
        subject = described_class.new
        expect(subject.gem_file_name).to match(/gemsmith/)
      end
    end

    context "when using default gem spec path in invalid directory" do
      it "fails with gemspec file path error" do
        Dir.chdir(temp_dir) do
          result = -> { described_class.new }
          expect(&result).to output("Invalid gemspec file path: .\n").to_stdout
        end
      end
    end

    context "when using custom gem spec path" do
      it "builds gem file name from gemspec" do
        subject = described_class.new gem_spec_path
        expect(subject.gem_file_name).to eq("tester-0.1.0.gem")
      end
    end

    context "when using invalid gem spec path" do
      it "fails with gemspec file path error" do
        result = -> { described_class.new "bogus" }
        expect(&result).to output("Invalid gemspec file path: bogus.\n").to_stdout
      end
    end
  end

  describe "#version_number" do
    it "answers current version number" do
      expect(subject.version_number).to eq("0.1.0")
    end
  end

  describe "#version_label" do
    it "answers current version label" do
      expect(subject.version_label).to eq("v0.1.0")
    end
  end

  describe "#gem_file_name" do
    it "answers versioned gem package file name" do
      expect((subject.gem_file_name)).to eq("tester-0.1.0.gem")
    end
  end

  describe "#publish" do
    it "publishes gem" do
      subject.publish
      expect(publisher).to have_received(:publish).with("0.1.0", sign: true)
    end

    it "fails with Milestoner error when error is encountered" do
      Dir.chdir(temp_dir) do
        subject = described_class.new gem_spec_path
        result = -> { subject.publish }

        expect(&result).to output("Invalid Git repository.\n").to_stdout
      end
    end
  end
end
