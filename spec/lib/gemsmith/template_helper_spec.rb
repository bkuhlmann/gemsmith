# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::TemplateHelper do
  let :cli do
    Class.new do
      include Gemsmith::TemplateHelper

      def configuration
        {
          gem: {
            name: "test_name",
            path: "test/path",
            class: "TestClass"
          },
          versions: {
            rails: "5.0.0"
          }
        }
      end
    end
  end
  subject { cli.new }

  describe "#gem_name" do
    it "answers gem name" do
      expect(subject.gem_name).to eq("test_name")
    end
  end

  describe "#gem_path" do
    it "answers gem path" do
      expect(subject.gem_path).to eq("test/path")
    end
  end

  describe "#gem_class" do
    it "answers gem class" do
      expect(subject.gem_class).to eq("TestClass")
    end
  end

  describe "#rails_version" do
    it "answers rails version" do
      expect(subject.rails_version).to eq("5.0.0")
    end
  end

  describe "#render_namespace" do
    it "renders with block"
    it "renders without block"
  end
end
