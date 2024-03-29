# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Bundler do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:test_configuration) { configuration.minimize }

  before { Rubysmith::Builders::Bundler.call test_configuration }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "with minimum flags" do
      let(:test_configuration) { configuration.minimize }

      it "builds gemspec" do
        expect(temp_dir.join("test", "Gemfile").read).to eq(<<~CONTENT)
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gemspec

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end
    end

    context "with maximum flags" do
      let(:test_configuration) { configuration.maximize }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gemspec

          group :quality do
            gem "caliber", "~> 0.51"
            gem "git-lint", "~> 7.1"
            gem "reek", "~> 6.3", require: false
            gem "simplecov", "~> 0.22", require: false
          end

          group :development do
            gem "rake", "~> 13.1"
          end

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.13"
          end

          group :tools do
            gem "amazing_print", "~> 1.6"
            gem "debug", "~> 1.9"
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds gemspec" do
        expect(temp_dir.join("test", "Gemfile").read).to eq(proof)
      end
    end
  end
end
