# frozen_string_literal: true

require "spec_helper"
require "dry/monads"

RSpec.describe Gemsmith::CLI::Actions::View do
  include Dry::Monads[:result, :maybe]

  subject(:action) { described_class.new picker:, viewer: }

  include_context "with application container"

  let(:picker) { instance_double Gemsmith::Gems::Picker, call: result }
  let(:viewer) { instance_double Gemsmith::Tools::Viewer, call: result }

  let :specification do
    Gemsmith::Gems::Loader.call Bundler.root.join("spec/support/fixtures/gemsmith-test.gemspec")
  end

  describe "#call" do
    context "when success" do
      let(:result) { Success specification }

      it "views gem" do
        expectation = proc { action.call "gemsmith-test" }
        expect(&expectation).to output("Viewing: gemsmith-test 0.0.0.\n").to_stdout
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
        expect(&expectation).to output("Unable to handle view action.\n").to_stdout
      end
    end
  end
end
