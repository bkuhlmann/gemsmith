# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Documentation::Readme do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:test_configuration) { configuration.minimize.merge build_readme: true }

  before { Rubysmith::Builders::Documentation::Readme.call test_configuration }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled with ASCII Doc format (minimum)" do
      let :test_configuration do
        configuration.minimize.merge build_readme: true, documentation_format: "adoc"
      end

      it "builds README" do
        expect(temp_dir.join("test/README.adoc").read).to eq(
          SPEC_ROOT.join("support/fixtures/readmes/minimum.adoc").read
        )
      end
    end

    context "when enabled with ASCII Doc format (maximum)" do
      let :test_configuration do
        configuration.maximize.merge documentation_format: "adoc", project_name: "test-example"
      end

      it "builds README" do
        expect(temp_dir.join("test-example/README.adoc").read).to eq(
          SPEC_ROOT.join("support/fixtures/readmes/maximum.adoc").read
        )
      end
    end

    context "when enabled with Markdown format (minimum)" do
      let :test_configuration do
        configuration.minimize.merge build_readme: true, documentation_format: "md"
      end

      it "builds README" do
        expect(temp_dir.join("test/README.md").read).to eq(
          SPEC_ROOT.join("support/fixtures/readmes/minimum.md").read
        )
      end
    end

    context "when enabled with Markdown format (maximum)" do
      let :test_configuration do
        configuration.maximize.merge documentation_format: "md", project_name: "test-example"
      end

      it "builds README" do
        expect(temp_dir.join("test-example/README.md").read).to eq(
          SPEC_ROOT.join("support/fixtures/readmes/maximum.md").read
        )
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build README" do
        expect(temp_dir.join("test/README.adoc").exist?).to be(false)
      end
    end
  end
end
