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
    Spek::Loader.call Bundler.root.join("spec/support/fixtures/gemsmith-test.gemspec")
  end

  describe "#call" do
    context "when success" do
      let(:result) { Success specification }

      it "views gem" do
        action.call "gemsmith-test"
        expect(logger.reread).to eq("Viewing: gemsmith-test 0.0.0.\n")
      end
    end

    context "when failure" do
      let(:result) { Failure "Danger!" }

      it "logs error" do
        action.call configuration
        expect(logger.reread).to eq("Danger!\n")
      end
    end

    context "when unknown" do
      let(:result) { Maybe "bogus" }

      it "logs error" do
        action.call configuration
        expect(logger.reread).to eq("Unable to handle view action.\n")
      end
    end
  end
end
