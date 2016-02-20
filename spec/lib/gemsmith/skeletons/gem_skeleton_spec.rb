# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::GemSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { instance_spy Gemsmith::Configuration, gem_name: "tester" }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
    before { subject.create }

    it "creates setup script" do
      expect(cli).to have_received(:template).with("%gem_name%/bin/setup.tt", configuration.to_h)
    end

    it "creates Gemfile" do
      expect(cli).to have_received(:template).with("%gem_name%/Gemfile.tt", configuration.to_h)
    end

    it "creates gem spec" do
      expect(cli).to have_received(:template).with("%gem_name%/%gem_name%.gemspec.tt", configuration.to_h)
    end

    it "creates gem library" do
      expect(cli).to have_received(:template).with("%gem_name%/lib/%gem_name%.rb.tt", configuration.to_h)
    end

    it "creates gem identity" do
      expect(cli).to have_received(:template).with("%gem_name%/lib/%gem_name%/identity.rb.tt", configuration.to_h)
    end
  end
end
