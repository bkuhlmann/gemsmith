# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::CircleCI do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/.circleci/config.yml" }

    context "when enabled" do
      before { settings.with! settings.with build_circle_ci: true }

      it "updates file to use gemspec for cache" do
        builder.call

        expect(path.read).to include(<<~CONTENT)
          version: 2.1
          jobs:
            build:
              working_directory: ~/project
              docker:
                - image: bkuhlmann/alpine-ruby:latest
              steps:
                - checkout

                - restore_cache:
                    name: Gems Restore
                    keys:
                      - gem-cache-{{.Branch}}-{{checksum "Gemfile"}}-{{checksum "test.gemspec"}}
                      - gem-cache-

                - run:
                    name: Gems Install
                    command: |
                      gem update --system
                      bundle config set path "vendor/bundle"
                      bundle install

                - save_cache:
                    name: Gems Store
                    key: gem-cache-{{.Branch}}-{{checksum "Gemfile"}}-{{checksum "test.gemspec"}}
                    paths:
                      - vendor/bundle

                - run:
                    name: Rake
                    command: bundle exec rake
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
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
