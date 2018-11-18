# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Credentials, :temp_dir do
  subject(:credentials) { described_class.new }

  let(:test_credentials_dir) { File.join temp_dir, ".gem" }
  let(:test_credentials_path) { File.join test_credentials_dir, "credentials" }
  let(:test_credentials) { {described_class::DEFAULT_KEY => "test"} }
  let(:loaded_credentials) { YAML.load_file test_credentials_path }

  describe ".file_path" do
    it "answers credentials file path" do
      ClimateControl.modify HOME: temp_dir.to_s do
        expect(described_class.file_path).to eq("#{temp_dir}/.gem/credentials")
      end
    end
  end

  describe "#authenticator" do
    context "with default" do
      it "answers RubyGems authenticator" do
        expect(credentials.authenticator).to eq(Gemsmith::Authenticators::RubyGems)
      end
    end

    context "with custom" do
      subject(:credentials) { described_class.new url: "https://www.example.com" }

      it "answers basic authenticator" do
        expect(credentials.authenticator).to eq(Gemsmith::Authenticators::Basic)
      end
    end
  end

  describe "#valid?" do
    before do
      FileUtils.mkdir test_credentials_dir
      File.open(test_credentials_path, "w") { |file| file << YAML.dump(test_credentials) }
    end

    it "answers true when file, key, and value exist" do
      ClimateControl.modify HOME: temp_dir.to_s do
        expect(credentials.valid?).to eq(true)
      end
    end

    context "when file exists and key is missing" do
      let(:test_credentials) { nil }

      it "answers false" do
        ClimateControl.modify HOME: temp_dir.to_s do
          expect(credentials.valid?).to eq(false)
        end
      end
    end

    context "when file exists and value is missing" do
      let(:test_credentials) { described_class::DEFAULT_KEY }

      it "answers false" do
        ClimateControl.modify HOME: temp_dir.to_s do
          expect(credentials.valid?).to eq(false)
        end
      end
    end

    context "when file exists and value is nil" do
      let(:test_credentials) { {described_class::DEFAULT_KEY => nil} }

      it "answers false" do
        ClimateControl.modify HOME: temp_dir.to_s do
          expect(credentials.valid?).to eq(false)
        end
      end
    end

    context "when file exists and value is blank" do
      let(:test_credentials) { {described_class::DEFAULT_KEY => ""} }

      it "answers false" do
        ClimateControl.modify HOME: temp_dir.to_s do
          expect(credentials.valid?).to eq(false)
        end
      end
    end

    it "answers false when file doesn't exist" do
      FileUtils.rm_rf test_credentials_dir
      ClimateControl.modify HOME: temp_dir.to_s do
        expect(credentials.valid?).to eq(false)
      end
    end
  end

  describe "#value" do
    context "when credentials exist" do
      before do
        FileUtils.mkdir test_credentials_dir
        File.open(test_credentials_path, "w") { |file| file << YAML.dump(test_credentials) }
      end

      it "answers value" do
        ClimateControl.modify HOME: temp_dir.to_s do
          expect(credentials.value).to eq("test")
        end
      end
    end

    context "when credentials don't exist" do
      it "answers value" do
        ClimateControl.modify HOME: temp_dir.to_s do
          expect(credentials.value).to eq("")
        end
      end
    end
  end

  describe "#create" do
    subject(:credentials) { described_class.new shell: shell }

    let(:login) { "tester" }
    let(:password) { "secret" }
    let(:authorization) { "authorized" }
    let(:authenticator_instance) { instance_spy authenticator_class, authorization: authorization }
    let(:shell) { instance_spy Thor::Shell::Basic }

    before do
      allow(authenticator_class).to receive(:new)
        .with(login, password)
        .and_return(authenticator_instance)
      allow(shell).to receive(:ask).with(%(What is your "#{url}" login?)).and_return(login)
      allow(shell).to receive(:ask)
        .with(%(What is your "#{url}" password?), echo: false)
        .and_return(password)
    end

    context "with RubyGems authentication" do
      let(:authenticator_class) { Gemsmith::Authenticators::RubyGems }
      let(:url) { "https://rubygems.org" }

      it "creates new credentials" do
        ClimateControl.modify HOME: temp_dir.to_s do
          credentials.create
          expect(loaded_credentials).to eq(rubygems_api_key: authorization)
        end
      end
    end

    context "with basic authentication" do
      subject(:credentials) { described_class.new key: :basic, url: url, shell: shell }

      let(:authenticator_class) { Gemsmith::Authenticators::Basic }
      let(:url) { "https://basic.example.com" }

      it "creates new credentials" do
        ClimateControl.modify HOME: temp_dir.to_s do
          credentials.create
          expect(loaded_credentials).to eq(basic: authorization)
        end
      end
    end

    context "with existing credentials" do
      let(:authenticator_class) { Gemsmith::Authenticators::RubyGems }
      let(:url) { "https://rubygems.org" }
      let(:test_credentials) { {test: "test"} }

      before do
        FileUtils.mkdir test_credentials_dir
        File.open(test_credentials_path, "w") { |file| file << YAML.dump(test_credentials) }
      end

      it "appends new credentials" do
        ClimateControl.modify HOME: temp_dir.to_s do
          credentials.create
          expect(loaded_credentials).to eq(test: "test", rubygems_api_key: authorization)
        end
      end
    end

    context "with duplicate credentials" do
      let(:authenticator_class) { Gemsmith::Authenticators::RubyGems }
      let(:url) { "https://rubygems.org" }
      let(:test_credentials) { {rubygems_api_key: "test"} }

      before do
        FileUtils.mkdir test_credentials_dir
        File.open(test_credentials_path, "w") { |file| file << YAML.dump(test_credentials) }
      end

      it "does not modify existing credentials" do
        ClimateControl.modify HOME: temp_dir.to_s do
          credentials.create
          expect(loaded_credentials).to eq(rubygems_api_key: "test")
        end
      end
    end
  end
end
