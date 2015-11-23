require "spec_helper"

describe Gemsmith::Git, :temp_dir do
  before do
    `printf "[user]\n" > "#{temp_dir}/.gitconfig"`
    `printf "  name = Test User\n" >> "#{temp_dir}/.gitconfig"`
    `printf "  email = test@example.com\n" >> "#{temp_dir}/.gitconfig"`
  end

  describe ".config_value" do
    it "answers string value for valid key" do
      ClimateControl.modify HOME: temp_dir do
        expect(Gemsmith::Git.config_value("user.name")).to eq("Test User")
      end
    end

    it "answers an empty string for invalid key" do
      ClimateControl.modify HOME: temp_dir do
        expect(Gemsmith::Git.config_value("bogus.bogus")).to eq("")
      end
    end
  end
end
