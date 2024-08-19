# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Bundler do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    context "with minimum flags" do
      before { settings.merge! settings.minimize }

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
      before { settings.merge! settings.maximize }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gemspec

          gem "bootsnap", "~> 1.18"

          group :quality do
            gem "caliber", "~> 0.58"
            gem "git-lint", "~> 8.0"
            gem "reek", "~> 6.3", require: false
            gem "simplecov", "~> 0.22", require: false
          end

          group :development do
            gem "rake", "~> 13.2"
          end

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.13"
          end

          group :tools do
            gem "amazing_print", "~> 1.6"
            gem "debug", "~> 1.9"
            gem "irb-kit", "~> 0.3"
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
