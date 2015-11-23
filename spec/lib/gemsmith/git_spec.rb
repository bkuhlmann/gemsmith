require "spec_helper"

describe Gemsmith::Git do
  describe ".config_value" do
    it "answers value for valid key" do
      allow(Gemsmith::Git).to receive(:'`').and_return("test")
      expect(Gemsmith::Git.config_value("user.name")).to eq("test")
    end

    it "answers nil for invalid key" do
      expect(Gemsmith::Git.config_value("bogus.bogus")).to eq(nil)
    end
  end
end
