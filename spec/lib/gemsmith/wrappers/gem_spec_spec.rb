# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Wrappers::GemSpec do
  let(:fixtures_dir) { File.join File.dirname(__FILE__), "..", "..", "..", "support", "fixtures" }
  let(:file_path) { File.join fixtures_dir, "tester-valid.gemspec" }
  let(:shell) { class_spy Open3 }
  subject { described_class.new file_path, shell: shell }

  describe ".editor" do
    it "answers current editor/IDE for editing source code" do
      ClimateControl.modify EDITOR: "sublime" do
        expect(described_class.editor).to eq("sublime")
      end
    end
  end

  describe ".find" do
    let(:specification) { class_spy ::Gem::Specification }
    before { allow(described_class).to receive(:specification).and_return(specification) }

    it "answers matching gem spec" do
      described_class.find "test", "1.0.0"
      expect(specification).to have_received(:find_by_name).with("test", "1.0.0")
    end
  end

  describe ".find_all" do
    let(:specification) { class_spy ::Gem::Specification }
    before { allow(described_class).to receive(:specification).and_return(specification) }

    it "answers matching gem specs" do
      described_class.find_all "test"
      expect(specification).to have_received(:find_all_by_name).with("test")
    end
  end

  describe "#initialize" do
    context "with valid gem specification" do
      it "does not raise error" do
        init = -> { described_class.new file_path }
        expect(&init).to_not raise_error
      end
    end

    context "with invalid file path" do
      it "raises unknown gem specification error" do
        init = -> { described_class.new "bogus_path" }
        expect(&init).to raise_error(Gemsmith::Errors::Specification, %(Unknown gem specification: "bogus_path".))
      end
    end

    context "with empty gem specification" do
      let(:file_path) { File.join fixtures_dir, "empty.gemspec" }

      it "raises unknown gem specification error" do
        init = -> { described_class.new file_path }
        expect(&init).to raise_error(Gemsmith::Errors::Specification, %(Unknown gem specification: "#{file_path}".))
      end
    end
  end

  describe "#homepage_url" do
    context "with homepage URL" do
      let(:file_path) { File.join fixtures_dir, "tester-homepage_url.gemspec" }

      it "URL" do
        expect(subject.homepage_url).to eq("https://www.example.com")
      end
    end

    context "without homepage URL" do
      it "answers empty string" do
        expect(subject.homepage_url).to eq("")
      end
    end
  end

  describe "#allowed_push_key" do
    context "with custom gemspec metadata" do
      let(:file_path) { File.join fixtures_dir, "tester-custom_metadata.gemspec" }

      it "answers custom key" do
        expect(subject.allowed_push_key).to eq("test")
      end
    end

    context "without gemspec metadata" do
      it "answers RubyGems key" do
        expect(subject.allowed_push_key).to eq("rubygems_api_key")
      end
    end
  end

  describe "#allowed_push_host" do
    context "with custom gemspec metadata" do
      let(:file_path) { File.join fixtures_dir, "tester-custom_metadata.gemspec" }

      it "answers custom host" do
        expect(subject.allowed_push_host).to eq("https://www.test.com")
      end
    end

    context "without gemspec metadata" do
      it "answers default host" do
        expect(subject.allowed_push_host).to eq("https://rubygems.org")
      end
    end
  end

  describe "#open_gem" do
    it "opens gem for editing" do
      subject.open_gem
      expect(shell).to have_received(:capture2).with(described_class.editor, /.+tester\-0\.1\.0/)
    end

    it "answers full path to installed gem source code" do
      expect(subject.open_gem).to match(/.+tester\-0\.1\.0/)
    end
  end

  describe "#open_homepage" do
    context "with homepage URL" do
      let(:file_path) { File.join fixtures_dir, "tester-homepage_url.gemspec" }

      it "opens gem for editing" do
        subject.open_homepage
        expect(shell).to have_received(:capture2).with("open", "https://www.example.com")
      end

      it "answers gem home page URL" do
        expect(subject.open_homepage).to eq("https://www.example.com")
      end
    end

    context "without homepage URL" do
      it "does nothing" do
        subject.open_homepage
        expect(shell).to have_received(:capture2).with("open", "")
      end
    end
  end

  describe "#version_number" do
    it "answers version number" do
      expect(subject.version_number).to eq("0.1.0")
    end
  end

  describe "#version_label" do
    it "answers version label" do
      expect(subject.version_label).to eq("v0.1.0")
    end
  end

  describe "#package_file_name" do
    it "answers package file name" do
      expect(subject.package_file_name).to eq("tester-0.1.0.gem")
    end
  end
end
