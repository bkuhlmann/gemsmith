# frozen_string_literal: true

require "spec_helper"
require "dry/monads"

RSpec.describe Gemsmith::CLI::Actions::Install do
  include Dry::Monads[:result]

  using Refinements::Pathnames

  subject(:action) { described_class.new installer: }

  include_context "with application container"

  let(:installer) { instance_spy Gemsmith::Tools::Installer, call: result }
  let(:specification) { Spek::Loader.call temp_dir.join("gemsmith-test.gemspec") }

  describe "#call" do
    before { Bundler.root.join("spec/support/fixtures/gemsmith-test.gemspec").copy temp_dir }

    context "when success" do
      let(:result) { Success specification }

      it "installs gem" do
        temp_dir.change_dir do
          action.call configuration
          expect(installer).to have_received(:call).with(kind_of(Spek::Presenter))
        end
      end

      it "logs gem was installed" do
        temp_dir.change_dir do
          action.call configuration
          expect(logger.reread).to eq("Installed: gemsmith-test-0.0.0.gem.\n")
        end
      end
    end

    context "when failure" do
      let(:result) { Failure "Danger!" }

      it "logs error" do
        temp_dir.change_dir do
          action.call configuration
          expect(logger.reread).to eq("Danger!\n")
        end
      end
    end

    context "when unknown" do
      let(:result) { "bogus" }

      it "logs error" do
        temp_dir.change_dir do
          action.call configuration
          expect(logger.reread).to eq("Unable to handle install action.\n")
        end
      end
    end
  end
end
