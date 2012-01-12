require "spec_helper"

describe Gemsmith::Kit do
  subject {Gemsmith::Kit}

  it "should answer git user name" do
    subject.should_receive(:'`').and_return("test")
    Gemsmith::Kit.git_config_value("user.name").should == "test"
  end

  it "should answer nil for invalid key" do
    Gemsmith::Kit.git_config_value("bogus").should be_nil
  end
end
