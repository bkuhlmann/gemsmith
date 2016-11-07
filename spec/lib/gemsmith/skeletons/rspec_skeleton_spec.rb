# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::RspecSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}, create: {rspec: create_rspec, rails: create_rails}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#create" do
    let(:create_rails) { false }
    before { subject.create }

    context "when enabled" do
      let(:create_rspec) { true }

      it "creates Rake file" do
        template = "%gem_name%/lib/tasks/rspec.rake.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end

      it "creates spec helper" do
        expect(cli).to have_received(:template).with("%gem_name%/spec/spec_helper.rb.tt", configuration)
      end

      it "does not create rails helper" do
        expect(cli).to_not have_received(:template).with("%gem_name%/spec/rails_helper.rb.tt", configuration)
      end

      it "creates shared contexts" do
        template = "%gem_name%/spec/support/shared_contexts/temp_dir.rb.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end
    end

    context "when Rails support is enabled" do
      let(:create_rspec) { true }
      let(:create_rails) { true }

      it "creates rails helper" do
        expect(cli).to have_received(:template).with("%gem_name%/spec/rails_helper.rb.tt", configuration)
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
