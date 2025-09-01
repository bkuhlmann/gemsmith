# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Git::Ignore do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    context "when enabled" do
      before { settings.minimize.with build_git: true }

      it "builds file" do
        builder.call

        expect(temp_dir.join("test/.gitignore").read).to eq(<<~CONTENT)
          *.gem
          .bundle
          Gemfile.lock
          pkg
          tmp
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.with! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(temp_dir.join("test/.gitignore").exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
