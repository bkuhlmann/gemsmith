# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Rspec, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }

  let :configuration do
    {
      gem: {
        name: "tester"
      },
      generate: {
        rspec: create_rspec,
        engine: create_engine,
        rails: create_rails
      }
    }
  end

  subject { described_class.new cli, configuration: configuration }

  describe "#run" do
    let(:create_rails) { false }
    let(:create_engine) { false }
    before { subject.run }

    context "when enabled" do
      let(:create_rspec) { true }

      it "enables Rakefile RSpec support" do
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /require.+rspec.+/)
        expect(cli).to have_received(:uncomment_lines).with("tester/Rakefile", /RSpec.+/)
      end

      it "creates spec helper" do
        template = "%gem_name%/spec/spec_helper.rb.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end

      it "does not create rails helper" do
        template = "%gem_name%/spec/rails_helper.rb.tt"
        expect(cli).to_not have_received(:template).with(template, configuration)
      end

      it "creates shared contexts" do
        template = "%gem_name%/spec/support/shared_contexts/temp_dir.rb.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end
    end

    context "when Engine support is enabled" do
      let(:create_rspec) { true }
      let(:create_engine) { true }

      it "creates rails helper" do
        template = "%gem_name%/spec/rails_helper.rb.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end
    end

    context "when Rails support is enabled" do
      let(:create_rspec) { true }
      let(:create_rails) { true }

      it "creates rails helper" do
        template = "%gem_name%/spec/rails_helper.rb.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end
    end

    context "when disabled" do
      let(:create_rspec) { false }

      it "does not uncomment lines" do
        expect(cli).to_not have_received(:uncomment_lines)
      end

      it "does not create files" do
        expect(cli).to_not have_received(:template)
      end
    end
  end
end
