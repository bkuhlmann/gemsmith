# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Gem::Specification do
  subject(:specification) { described_class.new file_path }

  let(:fixtures_dir) { File.join File.dirname(__FILE__), "..", "..", "..", "support", "fixtures" }
  let(:file_path) { File.join fixtures_dir, "tester-valid.gemspec" }

  describe ".find" do
    let(:gem_specification) { class_spy ::Gem::Specification }

    before { allow(described_class).to receive(:specification).and_return(gem_specification) }

    it "answers matching gem spec" do
      described_class.find "test", "1.0.0"
      expect(gem_specification).to have_received(:find_by_name).with("test", "1.0.0")
    end
  end

  describe ".find_all" do
    let(:gem_specification) { class_spy ::Gem::Specification }

    before { allow(described_class).to receive(:specification).and_return(gem_specification) }

    it "answers matching gem specs" do
      described_class.find_all "test"
      expect(gem_specification).to have_received(:find_all_by_name).with("test", ">= 0.0.0")
    end
  end

  describe "#initialize" do
    context "with valid gem specification" do
      it "does not raise error" do
        init = -> { described_class.new file_path }
        expect(&init).not_to raise_error
      end
    end

    context "with invalid file path" do
      it "raises unknown gem specification error" do
        init = -> { described_class.new "bogus_path" }

        expect(&init).to raise_error(
          Gemsmith::Errors::Specification,
          %(Unknown gem specification: "bogus_path".)
        )
      end
    end

    context "with empty gem specification" do
      let(:file_path) { File.join fixtures_dir, "empty.gemspec" }

      it "raises unknown gem specification error" do
        init = -> { described_class.new file_path }

        expect(&init).to raise_error(
          Gemsmith::Errors::Specification,
          %(Unknown gem specification: "#{file_path}".)
        )
      end
    end
  end

  describe "#name" do
    it "answers gem spec name" do
      expect(specification.name).to eq("tester")
    end
  end

  describe "#path" do
    it "answers gem spec path" do
      expect(specification.path).to eq(
        Bundler.root.join("spec", "support", "gems", "tester-0.1.0").to_s
      )
    end
  end

  describe "#homepage_url" do
    context "with homepage URL" do
      let(:file_path) { File.join fixtures_dir, "tester-homepage_url.gemspec" }

      it "URL" do
        expect(specification.homepage_url).to eq("https://www.example.com")
      end
    end

    context "without homepage URL" do
      it "answers empty string" do
        expect(specification.homepage_url).to eq("")
      end
    end
  end

  describe "#allowed_push_key" do
    context "with custom gemspec metadata" do
      let(:file_path) { File.join fixtures_dir, "tester-custom_metadata.gemspec" }

      it "answers custom key" do
        expect(specification.allowed_push_key).to eq("test")
      end
    end

    context "without gemspec metadata" do
      it "answers RubyGems key" do
        expect(specification.allowed_push_key).to eq("rubygems_api_key")
      end
    end
  end

  describe "#allowed_push_host" do
    context "with custom gemspec metadata" do
      let(:file_path) { File.join fixtures_dir, "tester-custom_metadata.gemspec" }

      it "answers custom host" do
        expect(specification.allowed_push_host).to eq("https://www.test.com")
      end
    end

    context "without gemspec metadata" do
      it "answers default host" do
        expect(specification.allowed_push_host).to eq("https://rubygems.org")
      end
    end
  end

  describe "#version" do
    it "answers version" do
      expect(specification.version).to eq(Versionaire::Version("0.1.0"))
    end
  end

  describe "#package_file_name" do
    it "answers package file name" do
      expect(specification.package_file_name).to eq("tester-0.1.0.gem")
    end
  end

  describe "#package_path" do
    it "answers relative package path" do
      expect(specification.package_path).to eq("pkg/tester-0.1.0.gem")
    end
  end
end
