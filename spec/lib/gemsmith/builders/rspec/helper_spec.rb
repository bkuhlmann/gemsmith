# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::RSpec::Helper do
  using Refinements::Struct
  using Refinements::Pathname

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/spec/spec_helper.rb" }

    context "when enabled with CLI and SimpleCov" do
      before do
        settings.merge! settings.minimize.merge(
          build_rspec: true,
          build_simple_cov: true,
          build_cli: true
        )
      end

      it "updates file" do
        builder.call
        expect(path.read).to include("add_filter %r((.+/container\\.rb|^/spec/))")
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled without CLI" do
      before { settings.merge! settings.minimize.merge(build_rspec: true, build_simple_cov: true) }

      it "updates file" do
        builder.call
        expect(path.read).not_to include("add_filter %r((.+/container\\.rb|^/spec/))")
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't update file" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
