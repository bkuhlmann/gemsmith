require "spec_helper"

RSpec.describe Gemsmith::Skeletons::RspecSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { instance_spy Gemsmith::Configuration, gem_name: "tester", create_rspec?: create_rspec }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }

  describe "#create" do
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

      it "creates gem spec" do
        template = "%gem_name%/spec/lib/%gem_name%/%gem_name%_spec.rb.tt"
        expect(cli).to have_received(:template).with(template, configuration.to_h)
      end

      it "creates default config" do
        template = "%gem_name%/spec/support/kit/default_config.rb.tt"
        expect(cli).to have_received(:template).with(template, configuration.to_h)
      end

      it "creates standard error support" do
        expect(cli).to have_received(:template).with("%gem_name%/spec/support/kit/stderr.rb.tt", configuration.to_h)
      end

      it "creates standard output support" do
        expect(cli).to have_received(:template).with("%gem_name%/spec/support/kit/stdout.rb.tt", configuration.to_h)
      end

      it "creates tempory directory support" do
        expect(cli).to have_received(:template).with("%gem_name%/spec/support/kit/temp_dir.rb.tt", configuration.to_h)
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
