# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Configuration::Loader do
  using Refinements::Structs

  subject(:loader) { described_class.new }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call).to be_a(Rubysmith::Configuration::Content)
    end
  end

  describe ".with_defaults" do
    it "answers configuration" do
      expect(described_class.with_defaults.call).to be_a(Rubysmith::Configuration::Content)
    end
  end

  describe ".with_overrides" do
    it "answers overrides" do
      expect(described_class.with_overrides.call).to have_attributes(
        target_root: Bundler.root,
        template_roots: [
          Bundler.root.join("lib/gemsmith/templates"),
          kind_of(Pathname)
        ]
      )
    end
  end

  describe "#call" do
    it "answers content with overrides" do
      expect(loader.call).to have_attributes(
        target_root: Bundler.root,
        template_roots: [
          Bundler.root.join("lib/gemsmith/templates"),
          kind_of(Pathname)
        ]
      )
    end
  end
end
