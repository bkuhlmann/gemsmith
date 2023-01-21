# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Specification do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "with minimum flags" do
      let(:test_configuration) { configuration.minimize }

      it "builds gemspec" do
        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          SPEC_ROOT.join("support/fixtures/test-minimum.gemspec").read
        )
      end
    end

    context "with minimum flags plus security" do
      let(:test_configuration) { configuration.minimize.merge build_security: true }

      it "builds gemspec" do
        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          SPEC_ROOT.join("support/fixtures/test-minimum-security.gemspec").read
        )
      end
    end

    context "with minimum flags plus CLI" do
      let :test_configuration do
        configuration.minimize.merge build_cli: true, build_refinements: true, build_zeitwerk: true
      end

      it "builds gemspec" do
        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          SPEC_ROOT.join("support/fixtures/test-minimum-cli.gemspec").read
        )
      end
    end

    context "with maximum flags" do
      let :test_configuration do
        configuration.maximize.merge(
          author_email: "jill@example.com",
          project_url_community: "https://www.example.com/%project_name%/community",
          project_url_conduct: "https://www.example.com/%project_name%/code_of_conduct",
          project_url_contributions: "https://www.example.com/%project_name%/contributions",
          project_url_download: "https://www.example.com/%project_name%/download",
          project_url_funding: "https://www.example.com/%project_name%/funding",
          project_url_home: "https://www.example.com/%project_name%",
          project_url_issues: "https://www.example.com/%project_name%/issues",
          project_url_license: "https://www.example.com/%project_name%/license",
          project_url_security: "https://www.example.com/%project_name%/security",
          project_url_source: "https://www.example.com/%project_name%/source",
          project_url_versions: "https://www.example.com/%project_name%/versions"
        )
      end

      it "builds gemspec" do
        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          SPEC_ROOT.join("support/fixtures/test-maximum.gemspec").read
        )
      end
    end
  end
end
