# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI::Actions::Config do
  subject(:action) { described_class.new }

  include_context "with application container"

  describe "#call" do
    it "edits configuration" do
      action.call :edit
      expect(kernel).to have_received(:system).with(include("EDITOR"))
    end

    it "views configuration" do
      action.call :view
      expect(kernel).to have_received(:system).with(include("cat"))
    end

    it "logs invalid configuration" do
      action.call :bogus
      expect(logger.reread).to match(/Invalid configuration selection: bogus./)
    end
  end
end
