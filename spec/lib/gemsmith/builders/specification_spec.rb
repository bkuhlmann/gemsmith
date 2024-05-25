# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Specification do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "with minimum flags" do
      let :test_configuration do
        configuration.minimize.merge(
          project_url_community: nil,
          project_url_conduct: nil,
          project_url_contributions: nil,
          project_url_download: nil,
          project_url_funding: nil,
          project_url_home: nil,
          project_url_issues: nil,
          project_url_license: nil,
          project_url_security: nil,
          project_url_source: nil,
          project_url_versions: nil
        )
      end

      it "builds gemspec" do
        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          SPEC_ROOT.join("support/fixtures/test-minimum.gemspec").read
        )
      end
    end

    context "with minimum flags plus security" do
      let :test_configuration do
        configuration.minimize.merge(
          build_security: true,
          project_url_community: nil,
          project_url_conduct: nil,
          project_url_contributions: nil,
          project_url_download: nil,
          project_url_funding: nil,
          project_url_home: nil,
          project_url_issues: nil,
          project_url_license: nil,
          project_url_security: nil,
          project_url_source: nil,
          project_url_versions: nil
        )
      end

      it "builds gemspec" do
        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          SPEC_ROOT.join("support/fixtures/test-minimum-security.gemspec").read
        )
      end
    end

    context "with minimum flags plus CLI" do
      let :test_configuration do
        configuration.minimize.merge(
          build_cli: true,
          build_refinements: true,
          build_zeitwerk: true,
          project_url_community: nil,
          project_url_conduct: nil,
          project_url_contributions: nil,
          project_url_download: nil,
          project_url_funding: nil,
          project_url_home: nil,
          project_url_issues: nil,
          project_url_license: nil,
          project_url_security: nil,
          project_url_source: nil,
          project_url_versions: nil
        )
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
          author_email: "jill@acme.io",
          project_url_community: "https://acme.io/%project_name%/community",
          project_url_conduct: "https://acme.io/%project_name%/code_of_conduct",
          project_url_contributions: "https://acme.io/%project_name%/contributions",
          project_url_download: "https://acme.io/%project_name%/download",
          project_url_funding: "https://acme.io/%project_name%/funding",
          project_url_home: "https://acme.io/%project_name%",
          project_url_issues: "https://acme.io/%project_name%/issues",
          project_url_license: "https://acme.io/%project_name%/license",
          project_url_security: "https://acme.io/%project_name%/security",
          project_url_source: "https://acme.io/%project_name%/source",
          project_url_versions: "https://acme.io/%project_name%/versions"
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
