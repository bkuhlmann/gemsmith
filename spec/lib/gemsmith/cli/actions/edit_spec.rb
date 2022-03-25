# frozen_string_literal: true

require "spec_helper"
require "dry/monads"

RSpec.describe Gemsmith::CLI::Actions::Edit do
  include Dry::Monads[:result, :maybe]

  subject(:action) { described_class.new picker:, editor: }

  include_context "with application container"

  let(:picker) { instance_double Spek::Picker, call: result }
  let(:editor) { instance_double Gemsmith::Tools::Editor, call: result }

  let :specification do
    Spek::Loader.call Bundler.root.join("spec/support/fixtures/gemsmith-test.gemspec")
  end

  describe "#call" do
    context "when success" do
      let(:result) { Success specification }

      it "edits gem" do
        action.call "gemsmith-test"
        expect(logger.reread).to eq("Editing: gemsmith-test 0.0.0.\n")
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
        expect(logger.reread).to eq("Unable to handle edit action.\n")
      end
    end
  end
end
