require "spec_helper"

describe Gemsmith::Skeletons::BaseSkeleton do
  let (:cli) { Gemsmith::CLI.new }
  let (:skeleton) { Gemsmith::Skeletons::BaseSkeleton.new cli }

  describe "#create" do
    it "messages methods prefixed with 'create_'" do
      skeleton.should_receive(:create_test_1).once
      skeleton.should_receive(:create_test_2).once
      skeleton.create
    end

    it "never messages methods not prefixed with 'create_'" do
      skeleton.should_receive(:bogus_method).never
      skeleton.create
    end
  end

  describe "#respond_to?" do
    it "responds to template" do
      skeleton.respond_to?("template").should be_true
    end

    it "responds to template_options" do
      skeleton.respond_to?("template_options").should be_true
    end

    it "responds to gem_name" do
      skeleton.respond_to?("gem_name").should be_true
    end

    it "responds to destination_root" do
      skeleton.respond_to?("destination_root").should be_true
    end

    it "does not responds to a bogus method" do
      skeleton.respond_to?("bogus_method").should be_false
    end
  end
end
