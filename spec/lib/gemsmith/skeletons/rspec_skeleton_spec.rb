# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::RspecSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let :configuration do
    instance_spy Gemsmith::Configuration, gem_name: "tester", create_rspec?: create_rspec, create_rails?: create_rails
  end
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
    let(:create_rails) { false }
    before { subject.create }

    context "when enabled" do
      let(:create_rspec) { true }

      it "creates Rake file" do
        template = "%gem_name%/lib/tasks/rspec.rake.tt"
        expect(cli).to have_received(:template).with(template, configuration.to_h)
      end

      it "creates spec helper" do
        expect(cli).to have_received(:template).with("%gem_name%/spec/spec_helper.rb.tt", configuration.to_h)
      end

      it "does not create rails helper" do
        expect(cli).to_not have_received(:template).with("%gem_name%/spec/rails_helper.rb.tt", configuration.to_h)
      end

      it "creates shared contexts" do
        template = "%gem_name%/spec/support/shared_contexts/temp_dir.rb.tt"
        expect(cli).to have_received(:template).with(template, configuration.to_h)
      end
    end

    context "when Rails support is enabled" do
      let(:create_rspec) { true }
      let(:create_rails) { true }

      it "creates rails helper" do
        expect(cli).to have_received(:template).with("%gem_name%/spec/rails_helper.rb.tt", configuration.to_h)
      end
    end

    context "when disabled" do
      let(:create_rspec) { false }

      it "does not create files" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
