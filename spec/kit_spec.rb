require "spec_helper"

describe Gemsmith::Kit do
  describe ".git_config_value" do
    it "answers value for valid key" do
      Gemsmith::Kit.should_receive(:'`').and_return("test")
      Gemsmith::Kit.git_config_value("user.name").should == "test"
    end

    it "answers nil for invalid key" do
      Gemsmith::Kit.git_config_value("bogus.bogus").should be_nil
    end
  end
end
