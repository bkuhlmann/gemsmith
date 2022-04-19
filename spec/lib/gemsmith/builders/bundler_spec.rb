# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Bundler do
  using Refinements::Structs

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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gemspec
        CONTENT
      end
    end

    context "with maximum flags" do
      let(:test_configuration) { configuration.maximize }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gemspec

          group :code_quality do
            gem "bundler-leak", "~> 0.2"
            gem "caliber", "~> 0.6"
            gem "git-lint", "~> 4.0"
            gem "reek", "~> 6.1"
            gem "simplecov", "~> 0.21"
          end

          group :development do
            gem "asciidoctor", "~> 2.0"
            gem "rake", "~> 13.0"
            gem "yard", "~> 0.9"
          end

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.11"
          end

          group :tools do
            gem "amazing_print", "~> 1.4"
            gem "debug", "~> 1.5"
          end
        CONTENT
      end

      it "builds gemspec" do
        expect(temp_dir.join("test", "Gemfile").read).to eq(proof)
      end
    end
  end
end
