# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Specification do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    context "with minimum flags" do
      before do
        settings.merge! settings.minimize.merge(
          project_uri_community: nil,
          project_uri_conduct: nil,
          project_uri_contributions: nil,
          project_uri_download: nil,
          project_uri_funding: nil,
          project_uri_home: nil,
          project_uri_issues: nil,
          project_uri_license: nil,
          project_uri_security: nil,
          project_uri_source: nil,
          project_uri_versions: nil
        )
      end

      it "builds gemspec" do
        builder.call

        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          SPEC_ROOT.join("support/fixtures/test-minimum.gemspec").read
        )
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "with minimum flags plus security" do
      before do
        settings.merge! settings.minimize.merge(
          build_security: true,
          project_uri_community: nil,
          project_uri_conduct: nil,
          project_uri_contributions: nil,
          project_uri_download: nil,
          project_uri_funding: nil,
          project_uri_home: nil,
          project_uri_issues: nil,
          project_uri_license: nil,
          project_uri_security: nil,
          project_uri_source: nil,
          project_uri_versions: nil
        )
      end

      it "builds gemspec" do
        builder.call

        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          SPEC_ROOT.join("support/fixtures/test-minimum-security.gemspec").read
        )
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "with minimum flags plus CLI" do
      before do
        settings.merge! settings.minimize.merge(
          build_cli: true,
          build_refinements: true,
          build_zeitwerk: true,
          project_uri_community: nil,
          project_uri_conduct: nil,
          project_uri_contributions: nil,
          project_uri_download: nil,
          project_uri_funding: nil,
          project_uri_home: nil,
          project_uri_issues: nil,
          project_uri_license: nil,
          project_uri_security: nil,
          project_uri_source: nil,
          project_uri_versions: nil
        )
      end

      it "builds gemspec" do
        builder.call

        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          SPEC_ROOT.join("support/fixtures/test-minimum-cli.gemspec").read
        )
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "with maximum flags" do
      before { settings.merge! settings.maximize }

      it "builds gemspec" do
        builder.call

        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          SPEC_ROOT.join("support/fixtures/test-maximum.gemspec").read
        )
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end
  end
end
