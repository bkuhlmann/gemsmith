# frozen_string_literal: true

require "rake"
require "refinements/pathnames"
require "tocer/rake/tasks"
require "gemsmith/gem/specification"
require "gemsmith/errors/base"
require "gemsmith/errors/specification"
require "gemsmith/rake/builder"
require "gemsmith/rake/publisher"

module Gemsmith
  module Rake
    # Provides Rake tasks for use in all gems built by this gem.
    class Tasks
      include ::Rake::DSL

      using Refinements::Pathnames

      def self.default_gem_spec
        Pathname.pwd.files("*.gemspec").first
      end

      def self.setup
        new.install
      end

      def initialize gem_spec: Gem::Specification.new(self.class.default_gem_spec.to_s),
                     builder: Rake::Builder.new,
                     publisher: Rake::Publisher.new
        @gem_spec = gem_spec
        @builder = builder
        @publisher = publisher
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      # :reek:TooManyStatements
      def install
        Tocer::Rake::Tasks.setup

        desc "Clean gem artifacts"
        task :clean do
          builder.clean
        end

        task :validate do
          builder.validate
        end

        desc "Build #{gem_package} package"
        task build: %i[clean toc validate] do
          builder.build gem_spec
        end

        desc "Install #{gem_package} package"
        task install: :build do
          builder.install gem_spec
        end

        desc "Build, tag as #{gem_spec.version} (#{signed_label}), " \
             "and push #{gem_package} to RubyGems"
        task publish: :build do
          publisher.publish
        end
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      private

      attr_reader :gem_spec, :builder, :publisher

      def gem_package
        gem_spec.package_file_name
      end

      def signed_label
        publisher.signed? ? "signed" : "unsigned"
      end
    end
  end
end
