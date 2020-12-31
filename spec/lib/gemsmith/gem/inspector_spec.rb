# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Gem::Inspector do
  subject(:inspector) { described_class.new shell: shell }

  let(:shell) { class_spy Open3 }

  let :specification do
    Bundler.root
           .join("spec/support/fixtures/tester-homepage_url.gemspec")
           .to_s
           .then { |path| Gemsmith::Gem::Specification.new path }
  end

  describe ".editor" do
    it "answers current editor/IDE for editing source code" do
      ClimateControl.modify EDITOR: "sublime" do
        expect(described_class.editor).to eq("sublime")
      end
    end
  end

  describe "#edit" do
    it "edits gem source code" do
      inspector.edit specification
      expect(shell).to have_received(:capture3).with(described_class.editor, /.+tester-0\.1\.0/)
    end
  end

  describe "#visit" do
    it "visits gem home page" do
      inspector.visit specification
      expect(shell).to have_received(:capture3).with("open", "https://www.example.com")
    end
  end
end
