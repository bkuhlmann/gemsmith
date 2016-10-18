# frozen_string_literal: true

require "open3"

module Gemsmith
  module Gem
    # A Gem::Specification with additional enhancements.
    class Specification
      def self.specification
        ::Gem::Specification
      end

      def self.default_gem_host
        ::Gem::DEFAULT_HOST
      end

      def self.editor
        ENV.fetch "EDITOR"
      end

      def self.find name, version
        specification.find_by_name name, version
      end

      def self.find_all name, requirement: Gem::Requirement.new.to_s
        specification.find_all_by_name name, requirement
      end

      def initialize file_path, shell: Open3
        @file_path = file_path
        @shell = shell
        @spec = self.class.specification.load file_path
        validate
      end

      def homepage_url
        String spec.homepage
      end

      def allowed_push_key
        spec.metadata.fetch("allowed_push_key") { "rubygems_api_key" }
      end

      def allowed_push_host
        spec.metadata.fetch("allowed_push_host") { self.class.default_gem_host }
      end

      def open_gem
        shell.capture2 self.class.editor, spec.full_gem_path
        String spec.full_gem_path
      end

      def open_homepage
        shell.capture2 "open", homepage_url
        homepage_url
      end

      def version_number
        spec.version.version
      end

      def version_label
        "v#{version_number}"
      end

      def package_file_name
        "#{spec.name}-#{version_number}.gem"
      end

      private

      attr_reader :file_path, :spec, :shell

      def validate
        return if spec.is_a?(self.class.specification)
        fail(Errors::Specification, %(Unknown gem specification: "#{file_path}".))
      end
    end
  end
end
