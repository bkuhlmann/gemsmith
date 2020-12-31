# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Rspec do
  subject(:rspec) { described_class.new cli, configuration: configuration }

  include_context "with temporary directory"

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }

  let :configuration do
    {
      gem: {
        name: "tester"
      },
      generate: {
        rspec: create_rspec,
        engine: create_engine
      }
    }
  end

  describe "#run" do
    let(:create_rails) { false }
    let(:create_engine) { false }

    before { rspec.run }

    context "when enabled" do
      let(:create_rspec) { true }

      it "does not remove Rakefile lines" do
        expect(cli).not_to have_received(:gsub_file)
      end

      it "creates spec helper" do
        template = "%gem_name%/spec/spec_helper.rb.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end

      it "does not create rails helper" do
        template = "%gem_name%/spec/rails_helper.rb.tt"
        expect(cli).not_to have_received(:template).with(template, configuration)
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

    context "when disabled" do
      let(:create_rspec) { false }

      it "removes Rakefile requirement" do
        expect(cli).to have_received(:gsub_file).with("tester/Rakefile", /require.+rspec.+\n/, "")
      end

      it "removes Rakefile task" do
        expect(cli).to have_received(:gsub_file).with("tester/Rakefile", /RSpec.+\n/, "")
      end

      it "does install templates" do
        expect(cli).not_to have_received(:template)
      end
    end
  end
end
