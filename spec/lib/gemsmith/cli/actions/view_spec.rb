# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Gemsmith::CLI::Actions::View do
  include Dry::Monads[:result, :maybe]

  subject(:action) { described_class.new picker:, viewer: }

  include_context "with application dependencies"

  let(:picker) { instance_double Spek::Picker, call: result }
  let(:viewer) { instance_double Gemsmith::Tools::Viewer, call: result }

  let :specification do
    Spek::Loader.call SPEC_ROOT.join("support/fixtures/gemsmith-test.gemspec")
  end

  describe "#call" do
    context "when success" do
      let(:result) { Success specification }

      it "views gem" do
        action.call "gemsmith-test"
        expect(logger.reread).to match(/🟢.+Viewing: gemsmith-test 0.0.0./)
      end
    end

    context "when failure" do
      let(:result) { Failure "Danger!" }

      it "logs error" do
        action.call configuration
        expect(logger.reread).to match(/🛑.+Danger!/)
      end
    end

    context "when unknown" do
      let(:result) { Maybe "bogus" }

      it "logs error" do
        action.call configuration
        expect(logger.reread).to match(/🛑.+Unable to handle view action./)
      end
    end
  end
end
