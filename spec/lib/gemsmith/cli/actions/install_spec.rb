# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Gemsmith::CLI::Actions::Install do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:action) { described_class.new installer: }

  include_context "with application dependencies"

  let(:installer) { instance_spy Gemsmith::Tools::Installer, call: result }
  let(:specification) { Spek::Loader.call temp_dir.join("gemsmith-test.gemspec") }

  describe "#call" do
    before { SPEC_ROOT.join("support/fixtures/gemsmith-test.gemspec").copy temp_dir }

    context "when success" do
      let(:result) { Success specification }

      it "installs gem" do
        temp_dir.change_dir do
          action.call
          expect(installer).to have_received(:call).with(kind_of(Spek::Presenter))
        end
      end

      it "logs gem was installed" do
        temp_dir.change_dir do
          action.call
          expect(logger.reread).to match(/🟢.+Installed: gemsmith-test-0.0.0.gem./)
        end
      end
    end

    context "when failure" do
      let(:result) { Failure "Danger!" }

      it "logs error" do
        temp_dir.change_dir do
          action.call
          expect(logger.reread).to match(/🛑.+Danger!/)
        end
      end
    end

    context "when unknown" do
      let(:result) { "bogus" }

      it "logs error" do
        temp_dir.change_dir do
          action.call
          expect(logger.reread).to match(/🛑.+Unable to handle install action./)
        end
      end
    end
  end
end
