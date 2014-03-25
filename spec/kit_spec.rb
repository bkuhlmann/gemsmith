require "spec_helper"

describe Gemsmith::Kit do
  describe ".git_config_value" do
    it "answers value for valid key" do
      allow(Gemsmith::Kit).to receive(:'`').and_return("test")
      expect(Gemsmith::Kit.git_config_value("user.name")).to eq("test")
    end

    it "answers nil for invalid key" do
      expect(Gemsmith::Kit.git_config_value("bogus.bogus")).to eq(nil)
    end
  end
end
