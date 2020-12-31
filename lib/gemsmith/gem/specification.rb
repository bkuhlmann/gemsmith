# frozen_string_literal: true

require "pathname"
require "versionaire"

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

      def self.find name, version
        specification.find_by_name name, version
      end

      def self.find_all name, requirement: Gem::Requirement.new.to_s
        specification.find_all_by_name name, requirement
      end

      attr_reader :version

      def initialize file_path
        @file_path = file_path
        @spec = self.class.specification.load file_path.to_s
        validate
        @version = Versionaire::Version @spec.version.to_s
      end

      def name
        spec.name
      end

      def path
        spec.full_gem_path
      end

      def homepage_url
        String spec.homepage
      end

      def allowed_push_key
        spec.metadata.fetch "allowed_push_key", "rubygems_api_key"
      end

      def allowed_push_host
        spec.metadata.fetch "allowed_push_host", self.class.default_gem_host
      end

      def package_file_name
        "#{name}-#{version}.gem"
      end

      def package_path
        Pathname("pkg").join package_file_name
      end

      private

      attr_reader :file_path, :spec

      def validate
        return if spec.is_a? self.class.specification

        fail Errors::Specification, %(Unknown gem specification: "#{file_path}".)
      end
    end
  end
end
