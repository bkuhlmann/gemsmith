# frozen_string_literal: true

require "bundler/gem_tasks"
require "gemsmith/gem/specification"
require "gemsmith/errors/base"
require "gemsmith/errors/specification"
require "gemsmith/rake/build"
require "gemsmith/rake/release"

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
        @build = Gemsmith::Rake::Build.new
        @release = Gemsmith::Rake::Release.new
      end

      def install
        ::Rake::Task[:build].enhance [:clean, :doc, :validate]
        ::Rake::Task[:release].clear

        desc "Update README (table of contents)"
        task :doc do
          build.doc
        end

        desc "Clean gem artifacts"
        task :clean do
          build.clean
        end

        task :validate do
          build.validate
        end

        desc "Build, tag #{gem_spec.version_label} (unsigned), and push #{gem_spec.package_file_name} to RubyGems"
        task release: :build do
          release.publish sign: false
        end

        desc "Build, tag #{gem_spec.version_label} (signed), and push #{gem_spec.package_file_name} to RubyGems"
        task publish: :build do
          release.publish
        end
      end

      private

      attr_reader :gem_spec, :build, :release
    end
  end
end
