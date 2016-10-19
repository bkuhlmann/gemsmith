# frozen_string_literal: true

require "spec_helper"
require "gemsmith/rake/builder"

RSpec.describe Gemsmith::Rake::Builder, :temp_dir do
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
      before { Dir.chdir(temp_dir) { `touch extra.txt` } }

      it "prints build error" do
        Dir.chdir temp_dir do
          result = -> { subject.validate }
          expect(&result).to output("Build failed: Gem has uncommitted changes.\n").to_stdout
        end
      end

      it "exits with error" do
        Dir.chdir temp_dir do
          subject.validate
          expect(kernel).to have_received(:exit).with(1)
        end
      end
    end

    context "without Git changes" do
      it "does not print output" do
        Dir.chdir temp_dir do
          result = -> { subject.validate }
          expect(&result).to_not output.to_stdout
        end
      end

      it "does not exit" do
        Dir.chdir temp_dir do
          subject.validate
          expect(kernel).to_not have_received(:exit)
        end
      end
    end
  end

  describe "#build" do
    let(:fixtures_dir) { File.join File.dirname(__FILE__), "..", "..", "..", "support", "fixtures" }
    let(:gem_spec_fixture_file) { File.join fixtures_dir, "tester-valid.gemspec" }
    let(:gem_spec_file) { File.join temp_dir, "tester.gemspec" }
    let(:gem_spec) { Gemsmith::Gem::Specification.new gem_spec_file }
    before { FileUtils.cp gem_spec_fixture_file, gem_spec_file }

    context "when success" do
      subject { described_class.new tocer: tocer_class }

      it "builds gem package" do
        Dir.chdir(temp_dir) do
          subject.build gem_spec
          expect(File.exist?("pkg/tester-0.1.0.gem")).to eq(true)
        end
      end

      it "prints package built successfully" do
        Dir.chdir(temp_dir) do
          result = -> { subject.build gem_spec }
          expect(&result).to output("Built: pkg/tester-0.1.0.gem.\n").to_stdout
        end
      end
    end

    context "when failure" do
      let(:kernel) { class_spy Kernel, system: false }

      it "does not build gem package" do
        Dir.chdir(temp_dir) do
          subject.build gem_spec
          expect(File.exist?("pkg/tester-0.1.0.gem")).to eq(false)
        end
      end

      it "prints error message" do
        Dir.chdir(temp_dir) do
          result = -> { subject.build gem_spec }
          expect(&result).to output("Unable to build: pkg/tester-0.1.0.gem.\n").to_stdout
        end
      end
    end
  end

  describe "#install" do
    let(:fixtures_dir) { File.join File.dirname(__FILE__), "..", "..", "..", "support", "fixtures" }
    let(:gem_spec_fixture_file) { File.join fixtures_dir, "tester-valid.gemspec" }
    let(:gem_spec) { Gemsmith::Gem::Specification.new gem_spec_fixture_file }

    context "when success" do
      let(:kernel) { class_spy Kernel, system: true }

      it "prints gem was installed" do
        result = -> { subject.install gem_spec }
        expect(&result).to output("Installed: tester 0.1.0.\n").to_stdout
      end
    end

    context "when failure" do
      let(:kernel) { class_spy Kernel, system: false }

      it "prints gem was installed" do
        result = -> { subject.install gem_spec }
        expect(&result).to output("Unable to install: tester 0.1.0.\n").to_stdout
      end
    end
  end
end
