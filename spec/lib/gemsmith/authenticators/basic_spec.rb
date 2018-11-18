# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Authenticators::Basic do
  subject(:basic) { described_class.new login, password }

  let(:login) { "admin" }
  let(:password) { "open_sesame" }

  describe "#authorization" do
    it "answers HTTP header authorization" do
      expect(basic.authorization).to match(/Basic\s[0-9a-zA-Z]{23}\=/)
    end
  end
end
