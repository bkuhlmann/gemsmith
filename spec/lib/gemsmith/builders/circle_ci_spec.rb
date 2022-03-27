# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::CircleCI do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:test_configuration) { configuration.minimize.merge build_circle_ci: true }
  let(:build_path) { temp_dir.join "test/.circleci/config.yml" }

  before { Rubysmith::Builders::CircleCI.call test_configuration }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_circle_ci: true }

      it "updates configuration to use gemspec for cache" do
        builder.call

        expect(build_path.read).to include(<<~CONTENT)
          version: 2.1
          jobs:
            build:
              working_directory: ~/project
              docker:
                - image: bkuhlmann/alpine-ruby:latest
              steps:
                - checkout

                - restore_cache:
                    name: Bundler Restore
                    keys:
                      - gem-cache-{{.Branch}}-{{checksum "Gemfile"}}-{{checksum "test.gemspec"}}
                      - gem-cache-

                - run:
                    name: Bundler Install
                    command: |
                      gem update --system
                      bundle config set path "vendor/bundle"
                      bundle install

                - save_cache:
                    name: Bundler Store
                    key: gem-cache-{{.Branch}}-{{checksum "Gemfile"}}-{{checksum "test.gemspec"}}
                    paths:
                      - vendor/bundle

                - run:
                    name: Build
                    command: bundle exec rake
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build configuration" do
        builder.call
        expect(build_path.exist?).to be(false)
      end
    end
  end
end
