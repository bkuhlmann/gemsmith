# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Gems::Presenter do
  using Versionaire::Cast

  subject(:presenter) { described_class.new record }

  let :record do
    Gem::Specification.load Bundler.root.join("spec/support/fixtures", fixture_file).to_s
  end

  let(:fixture_file) { "test-valid.gemspec" }

  describe "#initialize" do
    it "prints deprecatio warning" do
      expectation = proc { described_class.new record }
      expect(&expectation).to output(/DEPRECATION/).to_stderr
    end
  end

  describe "#allowed_push_key" do
    context "with custom gemspec metadata" do
      let(:fixture_file) { "test-custom_metadata.gemspec" }

      it "answers custom key" do
        expect(presenter.allowed_push_key).to eq("test")
      end
    end

    it "answers RubyGems key without custom metadata" do
      expect(presenter.allowed_push_key).to eq("rubygems_api_key")
    end
  end

  describe "#allowed_push_host" do
    context "with custom metadata" do
      let(:fixture_file) { "test-custom_metadata.gemspec" }

      it "answers custom host" do
        expect(presenter.allowed_push_host).to eq("https://www.test.com")
      end
    end

    it "answers default host without custom metadata" do
      expect(presenter.allowed_push_host).to eq("https://rubygems.org")
    end
  end

  describe "#homepage_url" do
    context "with homepage" do
      let(:fixture_file) { "test-homepage_url.gemspec" }

      it "answers URL" do
        expect(presenter.homepage_url).to eq("https://www.example.com/test")
      end
    end

    it "answers empty string without homepage" do
      expect(presenter.homepage_url).to eq("")
    end
  end

  describe "#label" do
    context "with custom metadata" do
      let(:fixture_file) { "test-custom_metadata.gemspec" }

      it "answers custom label" do
        expect(presenter.label).to eq("Test")
      end
    end

    it "answers undefined label" do
      expect(presenter.label).to eq("Undefined")
    end
  end

  describe "#labeled_summary" do
    it "answers label and summary" do
      expect(presenter.labeled_summary).to eq("Undefined - A test gem.")
    end

    it "answers label and summary with custom delimiter" do
      expect(presenter.labeled_summary(delimiter: ": ")).to eq("Undefined: A test gem.")
    end
  end

  describe "#labeled_version" do
    it "answers label and version" do
      expect(presenter.labeled_version).to eq("Undefined 0.0.0")
    end
  end

  describe "#metadata" do
    it "answers metadata" do
      expect(presenter.metadata).to eq("rubygems_mfa_required" => "true")
    end
  end

  describe "#name" do
    it "answers name" do
      expect(presenter.name).to eq("test")
    end
  end

  describe "#named_version" do
    it "answers name and version" do
      expect(presenter.named_version).to eq("test 0.0.0")
    end
  end

  describe "#package_path" do
    it "answers relative path" do
      expect(presenter.package_path).to eq(Pathname("tmp/test-0.0.0.gem"))
    end
  end

  describe "#package_name" do
    it "answers file name" do
      expect(presenter.package_name).to eq("test-0.0.0.gem")
    end
  end

  describe "#source_path" do
    it "answers gem path" do
      expect(presenter.source_path).to eq(Bundler.root.join("spec/support/gems/test-0.0.0"))
    end
  end

  describe "#summary" do
    it "answers gem summary" do
      expect(presenter.summary).to eq("A test gem.")
    end
  end

  describe "#version" do
    it "answers version" do
      expect(presenter.version).to eq(Version("0.0.0"))
    end
  end
end
