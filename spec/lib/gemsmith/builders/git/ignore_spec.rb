# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Git::Ignore do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    context "with enabled" do
      let(:test_configuration) { configuration.minimize.merge build_git: true }

      before do
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
    end

    context "with disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build file" do
        builder.call
        expect(temp_dir.join("test/.gitignore").exist?).to be(false)
      end
    end
  end
end
