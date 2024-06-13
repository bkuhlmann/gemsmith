# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Git::Ignore do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    context "when enabled" do
      before do
        settings.minimize.merge build_git: true

        temp_dir.join("test").make_path.join(".gitignore").write(<<~CONTENT)
          .bundle
          .rubocop-http*
          .yardoc
          doc/yard
          tmp
        CONTENT
      end

      it "builds Git ignore" do
        builder.call

        expect(temp_dir.join("test/.gitignore").read).to eq(<<~CONTENT)
          *.gem
          .bundle
          .rubocop-http*
          .yardoc
          doc/yard
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
      before { settings.merge! settings.minimize }

      it "does not build file" do
        builder.call
        expect(temp_dir.join("test/.gitignore").exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
