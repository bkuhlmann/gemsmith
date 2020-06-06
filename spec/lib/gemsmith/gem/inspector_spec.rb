# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Gem::Inspector do
  subject(:inspector) { described_class.new shell: shell }

  let(:fixtures_dir) { File.join File.dirname(__FILE__), "..", "..", "..", "support", "fixtures" }
  let(:specification_path) { File.join fixtures_dir, "tester-homepage_url.gemspec" }
  let(:specification) { Gemsmith::Gem::Specification.new specification_path }
  let(:shell) { class_spy Open3 }

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
      expect(shell).to have_received(:capture2).with(described_class.editor, /.+tester-0\.1\.0/)
    end
  end

  describe "#visit" do
    it "visits gem home page" do
      inspector.visit specification
      expect(shell).to have_received(:capture2).with("open", "https://www.example.com")
    end
  end
end
