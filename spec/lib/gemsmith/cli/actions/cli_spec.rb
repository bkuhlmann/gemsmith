# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI::Actions::CLI do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers nil without arguments" do
      action.call
      expect(settings.build_cli).to be(nil)
    end

    it "answers value when given agrument" do
      action.call true
      expect(settings.build_cli).to be(true)
    end
  end
end
