# frozen_string_literal: true

require "bundler/gem_tasks"
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

      def install
        build = Gemsmith::Rake::Build.new
        release = Gemsmith::Rake::Release.new

        ::Rake::Task[:build].enhance [:clean, :doc, :validate]
        ::Rake::Task[:release].enhance { ::Rake::Task[:clean].invoke }

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

        desc "Build, tag #{release.version_label} (signed), and push #{release.gem_file_name} to RubyGems"
        task publish: [:build, "release:guard_clean"] do
          release.publish
          ::Rake::Task["release:rubygem_push"].invoke
        end
      end
    end
  end
end
