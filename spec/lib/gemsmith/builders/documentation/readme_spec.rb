# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Documentation::Readme do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    context "when enabled with ASCII Doc format (minimum)" do
      before do
        settings.with! settings.minimize.with(build_readme: true, documentation_format: "adoc")
      end

      it "builds file" do
        builder.call

        expect(temp_dir.join("test/README.adoc").read).to eq(
          SPEC_ROOT.join("support/fixtures/readmes/minimum.adoc").read
        )
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with ASCII Doc format (maximum)" do
      before do
        settings.with! settings.maximize.with(
          documentation_format: "adoc",
          project_name: "test-example"
        )
      end

      it "builds file" do
        builder.call

        expect(temp_dir.join("test-example/README.adoc").read).to eq(
          SPEC_ROOT.join("support/fixtures/readmes/maximum.adoc").read
        )
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with Markdown format (minimum)" do
      before do
        settings.with! settings.minimize.with(build_readme: true, documentation_format: "md")
      end

      it "builds file" do
        builder.call

        expect(temp_dir.join("test/README.md").read).to eq(
          SPEC_ROOT.join("support/fixtures/readmes/minimum.md").read
        )
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with Markdown format (maximum)" do
      before do
        settings.with! settings.maximize.with(
          documentation_format: "md",
          project_name: "test-example"
        )
      end

      it "builds file" do
        builder.call

        expect(temp_dir.join("test-example/README.md").read).to eq(
          SPEC_ROOT.join("support/fixtures/readmes/maximum.md").read
        )
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.with! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(temp_dir.join("test/README.adoc").exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
