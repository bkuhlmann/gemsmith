# frozen_string_literal: true

require "bundler/gem_tasks"
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

      def self.setup
        new.install
      end

      def initialize
        @gem_spec = Gemsmith::Gem::Specification.new Dir.glob("#{Dir.pwd}/*.gemspec").first
        @builder = Gemsmith::Rake::Builder.new
        @publisher = Gemsmith::Rake::Publisher.new
      end

      def install
        ::Rake::Task[:build].enhance [:clean, :doc, :validate]
        ::Rake::Task[:release].clear

        desc "Update README (table of contents)"
        task :doc do
          builder.doc
        end

        desc "Clean gem artifacts"
        task :clean do
          builder.clean
        end

        task :validate do
          builder.validate
        end

        desc "Build, tag #{gem_spec.version_label} (unsigned), and push #{gem_spec.package_file_name} to RubyGems"
        task release: :build do
          publisher.publish sign: false
        end

        desc "Build, tag #{gem_spec.version_label} (signed), and push #{gem_spec.package_file_name} to RubyGems"
        task publish: :build do
          publisher.publish
        end
      end

      private

      attr_reader :gem_spec, :builder, :publisher
    end
  end
end
