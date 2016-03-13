# frozen_string_literal: true

require "spec_helper"
require "gemsmith/credentials"

RSpec.describe Gemsmith::Credentials, :temp_dir do
  let(:test_credentials_dir) { File.join temp_dir, ".gem" }
  let(:test_credentials_path) { File.join test_credentials_dir, "credentials" }
  let(:test_credentials) { {described_class.default_key => "test"} }
  let(:loaded_credentials) { YAML.load_file test_credentials_path }
  subject { described_class.new }

  describe ".file_path" do
    it "answers credentials file path" do
      ClimateControl.modify HOME: temp_dir do
        expect(described_class.file_path).to eq("#{temp_dir}/.gem/credentials")
      end
    end
  end

  describe "#authenticator" do
    context "with default" do
      it "answers RubyGems authenticator" do
        expect(subject.authenticator).to eq(Gemsmith::Authenticators::RubyGems)
      end
    end

    context "with custom" do
      subject { described_class.new url: "https://www.example.com" }

      it "answers basic authenticator" do
        expect(subject.authenticator).to eq(Gemsmith::Authenticators::Basic)
      end
    end
  end

  describe "#valid?" do
    context "when file exists" do
      before do
        FileUtils.mkdir test_credentials_dir
        File.open(test_credentials_path, "w") { |file| file << YAML.dump(test_credentials) }
      end

      context "when key and value exist" do
        it "answers true" do
          ClimateControl.modify HOME: temp_dir do
            expect(subject.valid?).to eq(true)
          end
        end
      end

      context "when key is missing" do
        let(:test_credentials) { nil }

        it "answers false" do
          ClimateControl.modify HOME: temp_dir do
            expect(subject.valid?).to eq(false)
          end
        end
      end

      context "when value is missing" do
        let(:test_credentials) { described_class.default_key }

        it "answers false" do
          ClimateControl.modify HOME: temp_dir do
            expect(subject.valid?).to eq(false)
          end
        end
      end

      context "when value is nil" do
        let(:test_credentials) { {described_class.default_key => nil} }

        it "answers false" do
          ClimateControl.modify HOME: temp_dir do
            expect(subject.valid?).to eq(false)
          end
        end
      end

      context "when value is blank" do
        let(:test_credentials) { {described_class.default_key => ""} }

        it "answers false" do
          ClimateControl.modify HOME: temp_dir do
            expect(subject.valid?).to eq(false)
          end
        end
      end
    end

    context "when file doesn't exist" do
      it "answers false" do
        ClimateControl.modify HOME: temp_dir do
          expect(subject.valid?).to eq(false)
        end
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
        ClimateControl.modify HOME: temp_dir do
          expect(subject.value).to eq("test")
        end
      end
    end

    context "when credentials don't exist" do
      it "answers value" do
        ClimateControl.modify HOME: temp_dir do
          expect(subject.value).to eq("")
        end
      end
    end
  end

  describe "#create" do
    let(:login) { "tester" }
    let(:password) { "secret" }
    let(:authorization) { "authorized" }
    let(:authenticator_instance) { instance_spy authenticator_class, authorization: authorization }
    let(:shell) { instance_spy Bundler::UI::Shell }
    subject { described_class.new shell: shell }
    before do
      allow(authenticator_class).to receive(:new).with(login, password).and_return(authenticator_instance)
      allow(shell).to receive(:ask).with(%(What is your "#{url}" login?)).and_return(login)
      allow(shell).to receive(:ask).with(%(What is your "#{url}" password?)).and_return(password)
    end

    context "with RubyGems authentication" do
      let(:authenticator_class) { Gemsmith::Authenticators::RubyGems }
      let(:url) { "https://rubygems.org" }

      it "creates new credentials" do
        ClimateControl.modify HOME: temp_dir do
          subject.create
          expect(loaded_credentials).to eq(rubygems_api_key: authorization)
        end
      end
    end

    context "with basic authentication" do
      let(:authenticator_class) { Gemsmith::Authenticators::Basic }
      let(:url) { "https://basic.example.com" }
      subject { described_class.new key: :basic, url: url, shell: shell }

      it "creates new credentials" do
        ClimateControl.modify HOME: temp_dir do
          subject.create
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
        ClimateControl.modify HOME: temp_dir do
          subject.create
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
        ClimateControl.modify HOME: temp_dir do
          subject.create
          expect(loaded_credentials).to eq(rubygems_api_key: "test")
        end
      end
    end
  end
end
