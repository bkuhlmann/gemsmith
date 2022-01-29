# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Gemsmith::Gems::Loader do
  using Versionaire::Cast

  subject(:loader) { described_class.new }

  describe ".call" do
    let(:path) { Bundler.root.join "spec/support/fixtures/gemsmith-test.gemspec" }

    it "answers specification" do
      expect(described_class.call(path)).to have_attributes(
        name: "gemsmith-test",
        version: Version("0.0.0")
      )
    end
  end

  describe "#initialize" do
    it "prints deprecation warning" do
      path = Bundler.root.join "spec/support/fixtures/gemsmith-test.gemspec"
      expectation = proc { loader.call path }

      expect(&expectation).to output(/DEPRECATION/).to_stderr
    end
  end

  describe "#call" do
    let(:path) { Bundler.root.join "spec/support/fixtures/gemsmith-test.gemspec" }

    it "answers specification" do
      loader.call path

      expect(loader.call(path)).to have_attributes(
        name: "gemsmith-test",
        version: Version("0.0.0")
      )
    end
  end
end
