require "spec_helper"

describe Gemsmith::Kit do
  it "should answer git user name" do
    Gemsmith::Kit.git_config_value("user.name").should == `git config user.name`.chomp
  end

  it "should answer nil for invalid key" do
    Gemsmith::Kit.git_config_value("bogus").should be_nil
  end
end
