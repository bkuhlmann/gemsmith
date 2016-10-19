# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Configuration, :temp_dir do
  let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-empty" }
  let(:resource_path) { File.join temp_dir, Gemsmith::Identity.file_name }
  let(:git) { class_spy Gemsmith::Git }
  subject { described_class.new file_path: resource_path, git: git }
  before { FileUtils.cp fixture_path, resource_path }

  describe "#initialize" do
    context "with invalid file path" do
      subject { described_class.new file_path: ".bogusrc" }

      it "answers defaults" do
        expect(subject.gem_name).to eq("unknown")
      end
    end
  end

  describe "#gem_name" do
    context "with default settings" do
      it "answers gem name" do
        expect(subject.gem_name).to eq("unknown")
      end
    end

    context "with custom settings" do
      subject { described_class.new gem_name: "example" }

      it "answers gem name" do
        expect(subject.gem_name).to eq("example")
      end
    end
  end

  describe "#gem_class" do
    context "with default settings" do
      it "answers gem class" do
        expect(subject.gem_class).to eq("Unknown")
      end
    end

    context "with custom settings" do
      subject { described_class.new gem_class: "Example" }

      it "answers gem name" do
        expect(subject.gem_class).to eq("Example")
      end
    end
  end

  describe "#gem_platform" do
    context "with default resource file" do
      it "answers gem platform" do
        expect(subject.gem_platform).to eq("Gem::Platform::RUBY")
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers gem platform" do
        expect(subject.gem_platform).to eq("Gem::Platform::CURRENT")
      end
    end

    context "with overwritten settings" do
      it "answers gem platform" do
        subject.gem_platform = "Gem::Platform::OVERWRITTEN"
        expect(subject.gem_platform).to eq("Gem::Platform::OVERWRITTEN")
      end
    end
  end

  describe "#gem_home_url" do
    context "with default resource file" do
      it "answers gem home URL" do
        subject.gem_home_url
        expect(git).to have_received(:config_value).with("github.user").twice
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers gem home URL" do
        expect(subject.gem_home_url).to eq("https://www.example.com")
      end
    end

    context "with overwritten settings" do
      it "answers gem home URL" do
        subject.gem_home_url = "https://overwritten.example.com"
        expect(subject.gem_home_url).to eq("https://overwritten.example.com")
      end
    end
  end

  describe "#gem_license" do
    context "with default resource file" do
      it "answers gem license" do
        expect(subject.gem_license).to eq("MIT")
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers gem license" do
        expect(subject.gem_license).to eq("Apache")
      end
    end

    context "with overwritten settings" do
      it "answers gem license" do
        subject.gem_license = "GPL"
        expect(subject.gem_license).to eq("GPL")
      end
    end
  end

  describe "#author_name" do
    context "with default resource file" do
      it "answers author name" do
        subject.author_name
        expect(git).to have_received(:config_value).with("user.name")
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers author name" do
        expect(subject.author_name).to eq("Author Name")
      end
    end

    context "with overwritten settings" do
      it "answers author name" do
        subject.author_name = "Overwritten"
        expect(subject.author_name).to eq("Overwritten")
      end
    end
  end

  describe "#author_email" do
    context "with default resource file" do
      it "answers author email" do
        subject.author_email
        expect(git).to have_received(:config_value).with("user.email")
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers author email" do
        expect(subject.author_email).to eq("author@example.com")
      end
    end

    context "with overwritten settings" do
      it "answers author email" do
        subject.author_email = "overwritten@example.com"
        expect(subject.author_email).to eq("overwritten@example.com")
      end
    end
  end

  describe "#author_url" do
    context "with default resource file" do
      it "answers author URL" do
        expect(subject.author_url).to eq("")
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers author URL" do
        expect(subject.author_url).to eq("https://author.example.com")
      end
    end

    context "with overwritten settings" do
      it "answers author URL" do
        subject.author_url = "https://overwritten.example.com"
        expect(subject.author_url).to eq("https://overwritten.example.com")
      end
    end
  end

  describe "#organization_name" do
    context "with default resource file" do
      it "answers organization name" do
        expect(subject.organization_name).to eq("")
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers organization name" do
        expect(subject.organization_name).to eq("Org Name")
      end
    end

    context "with overwritten settings" do
      it "answers organization name" do
        subject.organization_name = "Overwritten"
        expect(subject.organization_name).to eq("Overwritten")
      end
    end
  end

  describe "#organization_url" do
    context "with default resource file" do
      it "answers organization URL" do
        expect(subject.organization_url).to eq("")
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers organization URL" do
        expect(subject.organization_url).to eq("https://org.example.com")
      end
    end

    context "with overwritten settings" do
      it "answers organization URL" do
        subject.organization_url = "https://overwritten.example.com"
        expect(subject.organization_url).to eq("https://overwritten.example.com")
      end
    end
  end

  describe "#ruby_version" do
    context "with default resource file" do
      it "answers Ruby version" do
        stub_const "RUBY_VERSION", "2.0.0"
        expect(subject.ruby_version).to eq("2.0.0")
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers Ruby version" do
        expect(subject.ruby_version).to eq("1.1.1")
      end
    end

    context "with overwritten settings" do
      it "answers Ruby version" do
        subject.ruby_version = "1.0.0"
        expect(subject.ruby_version).to eq("1.0.0")
      end
    end
  end

  describe "#rails_version" do
    context "with default resource file" do
      it "answers Rails version" do
        expect(subject.rails_version).to eq("5.0")
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers Rails version" do
        expect(subject.rails_version).to eq("2.2.2")
      end
    end

    context "with overwritten settings" do
      it "answers Rails version" do
        subject.rails_version = "2.0.0"
        expect(subject.rails_version).to eq("2.0.0")
      end
    end
  end

  describe "#create_cli?" do
    context "with default resource file" do
      it "answers false" do
        expect(subject.create_cli?).to eq(false)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers true" do
        expect(subject.create_cli?).to eq(true)
      end
    end

    context "with overwritten settings" do
      it "answers true" do
        subject.create_cli = true
        expect(subject.create_cli?).to eq(true)
      end
    end
  end

  describe "#create_rails?" do
    context "with default resource file" do
      it "answers false" do
        expect(subject.create_rails?).to eq(false)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers true" do
        expect(subject.create_rails?).to eq(true)
      end
    end

    context "with overwritten settings" do
      it "answers true" do
        subject.create_rails = true
        expect(subject.create_rails?).to eq(true)
      end
    end
  end

  describe "#create_security?" do
    context "with default resource file" do
      it "answers true" do
        expect(subject.create_security?).to eq(true)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers false" do
        expect(subject.create_security?).to eq(false)
      end
    end

    context "with overwritten settings" do
      it "answers false" do
        subject.create_security = false
        expect(subject.create_security?).to eq(false)
      end
    end
  end

  describe "#create_pry?" do
    context "with default resource file" do
      it "answers true" do
        expect(subject.create_pry?).to eq(true)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers false" do
        expect(subject.create_pry?).to eq(false)
      end
    end

    context "with overwritten settings" do
      it "answers false" do
        subject.create_pry = false
        expect(subject.create_pry?).to eq(false)
      end
    end
  end

  describe "#create_guard?" do
    context "with default resource file" do
      it "answers true" do
        expect(subject.create_guard?).to eq(true)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers false" do
        expect(subject.create_guard?).to eq(false)
      end
    end

    context "with overwritten settings" do
      it "answers false" do
        subject.create_guard = false
        expect(subject.create_guard?).to eq(false)
      end
    end
  end

  describe "#create_rspec?" do
    context "with default resource file" do
      it "answers true" do
        expect(subject.create_rspec?).to eq(true)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers false" do
        expect(subject.create_rspec?).to eq(false)
      end
    end

    context "with overwritten settings" do
      it "answers false" do
        subject.create_rspec = false
        expect(subject.create_rspec?).to eq(false)
      end
    end
  end

  describe "#create_rubocop?" do
    context "with default resource file" do
      it "answers true" do
        expect(subject.create_rubocop?).to eq(true)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers false" do
        expect(subject.create_rubocop?).to eq(false)
      end
    end

    context "with overwritten settings" do
      it "answers false" do
        subject.create_rubocop = false
        expect(subject.create_rubocop?).to eq(false)
      end
    end
  end

  describe "#create_git_hub?" do
    context "with default resource file" do
      it "answers false" do
        expect(subject.create_git_hub?).to eq(false)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers true" do
        expect(subject.create_git_hub?).to eq(true)
      end
    end

    context "with overwritten settings" do
      it "answers true" do
        subject.create_git_hub = true
        expect(subject.create_git_hub?).to eq(true)
      end
    end
  end

  describe "#create_code_climate?" do
    context "with default resource file" do
      it "answers true" do
        expect(subject.create_code_climate?).to eq(true)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers false" do
        expect(subject.create_code_climate?).to eq(false)
      end
    end

    context "with overwritten settings" do
      it "answers false" do
        subject.create_code_climate = false
        expect(subject.create_code_climate?).to eq(false)
      end
    end
  end

  describe "#create_gemnasium?" do
    context "with default resource file" do
      it "answers true" do
        expect(subject.create_gemnasium?).to eq(true)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers false" do
        expect(subject.create_gemnasium?).to eq(false)
      end
    end

    context "with overwritten settings" do
      it "answers false" do
        subject.create_gemnasium = false
        expect(subject.create_gemnasium?).to eq(false)
      end
    end
  end

  describe "#create_travis?" do
    context "with default resource file" do
      it "answers true" do
        expect(subject.create_travis?).to eq(true)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers false" do
        expect(subject.create_travis?).to eq(false)
      end
    end

    context "with overwritten settings" do
      it "answers false" do
        subject.create_travis = false
        expect(subject.create_travis?).to eq(false)
      end
    end
  end

  describe "#create_patreon?" do
    context "with default resource file" do
      it "answers true" do
        expect(subject.create_patreon?).to eq(true)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers false" do
        expect(subject.create_patreon?).to eq(false)
      end
    end

    context "with overwritten settings" do
      it "answers false" do
        subject.create_patreon = false
        expect(subject.create_patreon?).to eq(false)
      end
    end
  end

  describe "#github_user" do
    context "with default resource file" do
      it "answers GitHub user" do
        subject.github_user
        expect(git).to have_received(:config_value).with("github.user")
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers GitHub user" do
        expect(subject.github_user).to eq("example")
      end
    end

    context "with overwritten settings" do
      it "answers GitHub user" do
        subject.github_user = "overwritten"
        expect(subject.github_user).to eq("overwritten")
      end
    end
  end

  describe "#year" do
    context "with default resource file" do
      it "answers year" do
        expect(subject.year).to eq(Time.now.utc.year)
      end
    end

    context "with custom resource file" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "support", "fixtures", ".gemsmithrc-custom" }

      it "answers year" do
        expect(subject.year).to eq("2000")
      end
    end

    context "with overwritten settings" do
      it "answers year" do
        subject.year = "2022"
        expect(subject.year).to eq("2022")
      end
    end
  end

  describe "#to_h" do
    let :defaults do
      {
        year: Time.now.year,
        github_user: "tester",
        gem: {
          name: "unknown",
          class: "Unknown",
          platform: "Gem::Platform::RUBY",
          home_url: "https://github.com/tester/unknown",
          license: "MIT"
        },
        author: {
          name: "Test",
          email: "test@example.com",
          url: ""
        },
        organization: {
          name: "",
          url: ""
        },
        versions: {
          ruby: "2.0.0",
          rails: "5.0"
        },
        create: {
          cli: false,
          rails: false,
          security: true,
          pry: true,
          guard: true,
          rspec: true,
          rubocop: true,
          git_hub: false,
          code_climate: true,
          gemnasium: true,
          travis: true,
          patreon: true
        }
      }
    end

    before do
      allow(git).to receive(:config_value).with("github.user").and_return("tester")
      allow(git).to receive(:config_value).with("user.name").and_return("Test")
      allow(git).to receive(:config_value).with("user.email").and_return("test@example.com")
    end

    it "answers configuration as a hash" do
      stub_const "RUBY_VERSION", "2.0.0"
      expect(subject.to_h).to eq(defaults)
    end
  end
end
