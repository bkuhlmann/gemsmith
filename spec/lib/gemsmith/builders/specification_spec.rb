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
          Bundler.root.join("spec/support/fixtures/test-minimum-metadata.gemspec").read
        )
      end
    end

    context "with minimum and no project URLs" do
      let :test_configuration do
        configuration.minimize.merge project_url_community: nil,
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
      end

      it "builds gemspec" do
        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          Bundler.root.join("spec/support/fixtures/test-minimum.gemspec").read
        )
      end
    end

    context "with security only" do
      let(:test_configuration) { configuration.minimize.merge build_security: true }

      it "builds gemspec" do
        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          Bundler.root.join("spec/support/fixtures/test-security_only.gemspec").read
        )
      end
    end

    context "with CLI only" do
      let :test_configuration do
        configuration.minimize.merge build_cli: true, build_refinements: true, build_zeitwerk: true
      end

      it "builds gemspec" do
        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          Bundler.root.join("spec/support/fixtures/test-cli_only.gemspec").read
        )
      end
    end

    context "with maximum flags" do
      let(:test_configuration) { configuration.maximize }

      it "builds gemspec" do
        expect(temp_dir.join("test", "test.gemspec").read).to eq(
          Bundler.root.join("spec/support/fixtures/test-maximum.gemspec").read
        )
      end
    end
  end
end
