require "spec_helper"

describe Gemsmith::Skeletons::BaseSkeleton do
  let(:cli) { Gemsmith::CLI.new }
  let(:skeleton) { Gemsmith::Skeletons::BaseSkeleton.new cli }

  describe "#create" do
    it "messages methods prefixed with 'create_'" do
      def skeleton.create_test
      end

      expect(skeleton).to receive(:create_test).once
      skeleton.create
    end
  end

  describe "#respond_to?" do
    it "responds to template" do
      expect(skeleton.respond_to?("template")).to eq(true)
    end

    it "responds to template_options" do
      expect(skeleton.respond_to?("template_options")).to eq(true)
    end

    it "responds to gem_name" do
      expect(skeleton.respond_to?("gem_name")).to eq(true)
    end

    it "responds to destination_root" do
      expect(skeleton.respond_to?("destination_root")).to eq(true)
    end

    it "does not respond to a bogus method" do
      expect(skeleton.respond_to?("bogus_method")).to eq(false)
    end
  end
end
