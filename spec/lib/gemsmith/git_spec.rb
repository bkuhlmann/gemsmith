# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Git, :temp_dir do
  before do
    `printf "[user]\n" > "#{temp_dir}/.gitconfig"`
    `printf "  name = Test User\n" >> "#{temp_dir}/.gitconfig"`
    `printf "  email = test@example.com\n" >> "#{temp_dir}/.gitconfig"`
  end

  describe ".config_value" do
    it "answers string value for valid key" do
      ClimateControl.modify HOME: temp_dir do
        expect(described_class.config_value("user.name")).to eq("Test User")
      end
    end

    it "answers an empty string for invalid key" do
      ClimateControl.modify HOME: temp_dir do
        expect(described_class.config_value("bogus.bogus")).to eq("")
      end
    end
  end

  describe ".github_user" do
    context "when GitHub user exists" do
      before do
        `printf "[github]\n" >> "#{temp_dir}/.gitconfig"`
        `printf "  user = test\n" >> "#{temp_dir}/.gitconfig"`
      end

      it "answers GitHub user" do
        ClimateControl.modify HOME: temp_dir do
          expect(described_class.github_user).to eq("test")
        end
      end
    end

    context "when GitHub user doesn't exist" do
      it "answers empty string" do
        ClimateControl.modify HOME: temp_dir do
          expect(described_class.github_user).to eq("")
        end
      end
    end
  end

  describe ".github_url" do
    let(:project) { "example" }

    context "when GitHub user exists" do
      before do
        `printf "[github]\n" >> "#{temp_dir}/.gitconfig"`
        `printf "  user = test\n" >> "#{temp_dir}/.gitconfig"`
      end

      it "answers GitHub URL" do
        ClimateControl.modify HOME: temp_dir do
          expect(described_class.github_url(project)).to eq("https://github.com/test/#{project}")
        end
      end
    end

    context "when GitHub user doesn't exist" do
      it "answers empty string" do
        ClimateControl.modify HOME: temp_dir do
          expect(described_class.github_url(project)).to eq("")
        end
      end
    end
  end
end
