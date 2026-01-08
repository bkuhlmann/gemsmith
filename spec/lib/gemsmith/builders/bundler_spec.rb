# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Bundler do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    context "with minimum flags" do
      before { settings.with! settings.minimize }

      it "builds gemspec" do
        builder.call

        expect(temp_dir.join("test", "Gemfile").read).to eq(<<~CONTENT)
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gemspec
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "with maximum flags" do
      before { settings.with! settings.maximize }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gemspec

          gem "bootsnap", "~> 1.18"

          group :quality do
            gem "caliber", "~> 0.87"
            gem "git-lint", "~> 10.0"
            gem "reek", "~> 6.5", require: false
            gem "simplecov", "~> 0.22", require: false
          end

          group :development do
            gem "rake", "~> 13.3"
          end

          group :test do
            gem "rspec", "~> 3.13"
          end

          group :tools do
            gem "amazing_print", "~> 2.0"
            gem "debug", "~> 1.11"
            gem "irb-kit", "~> 2.0"
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds gemspec" do
        builder.call
        expect(temp_dir.join("test", "Gemfile").read).to eq(proof)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end
  end
end
