# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Gemsmith::CLI::Actions::Publish do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:action) { described_class.new publisher: }

  include_context "with application dependencies"

  let(:publisher) { instance_spy Gemsmith::Tools::Publisher, call: result }
  let(:specification) { Spek::Loader.call temp_dir.join("gemsmith-test.gemspec") }

  describe "#call" do
    before { SPEC_ROOT.join("support/fixtures/gemsmith-test.gemspec").copy temp_dir }

    context "when success" do
      let(:result) { Success specification }

      it "publishes gem" do
        temp_dir.change_dir do
          action.call configuration
          expect(publisher).to have_received(:call).with(kind_of(Spek::Presenter))
        end
      end

      it "logs gem was published" do
        temp_dir.change_dir do
          action.call configuration
          expect(logger.reread).to match(/🟢.+Published: gemsmith-test-0.0.0.gem./)
        end
      end
    end

    context "when failure" do
      let(:result) { Failure "Danger!" }

      it "logs error" do
        temp_dir.change_dir do
          action.call configuration
          expect(logger.reread).to match(/🛑.+Danger!/)
        end
      end
    end

    context "when unknown" do
      let(:result) { "bogus" }

      it "logs error" do
        temp_dir.change_dir do
          action.call configuration
          expect(logger.reread).to match(/🛑.+Unable to handle publish action./)
        end
      end
    end
  end
end
