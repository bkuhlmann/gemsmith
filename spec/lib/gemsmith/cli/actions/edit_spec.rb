# frozen_string_literal: true

require "spec_helper"
require "dry/monads"

RSpec.describe Gemsmith::CLI::Actions::Edit do
  include Dry::Monads[:result, :maybe]

  subject(:action) { described_class.new picker:, editor: }

  include_context "with application container"

  let(:picker) { instance_double Gemsmith::Gems::Picker, call: result }
  let(:editor) { instance_double Gemsmith::Tools::Editor, call: result }

  let :specification do
    Gemsmith::Gems::Loader.call Bundler.root.join("spec/support/fixtures/gemsmith-tester.gemspec")
  end

  describe "#call" do
    context "when success" do
      let(:result) { Success specification }

      it "edits gem" do
        expectation = proc { action.call "gemsmith-tester" }
        expect(&expectation).to output("Editing: gemsmith-tester 0.0.0.\n").to_stdout
      end
    end

    context "when failure" do
      let(:result) { Failure "Danger!" }

      it "logs error" do
        expectation = proc { action.call configuration }
        expect(&expectation).to output("Danger!\n").to_stdout
      end
    end

    context "when unknown" do
      let(:result) { Maybe "bogus" }

      it "logs error" do
        expectation = proc { action.call configuration }
        expect(&expectation).to output("Unable to handle edit action.\n").to_stdout
      end
    end
  end
end
