# frozen_string_literal: true

require "forwardable"
require "pathname"
require "refinements/arrays"
require "versionaire"

module Gemsmith
  module Gems
    # Provides a gem specification that is more useful than what is provided Ruby Gems.
    class Presenter
      extend Forwardable

      using Refinements::Arrays
      using Versionaire::Cast

      delegate %i[metadata name summary] => :record

      def initialize record
        @record = record
      end

      def allowed_push_key = metadata.fetch "allowed_push_key", "rubygems_api_key"

      def allowed_push_host = metadata.fetch "allowed_push_host", ::Gem::DEFAULT_HOST

      def homepage_url = String record.homepage

      def label = metadata.fetch "label", "Undefined"

      def labeled_summary(delimiter: " - ") = [label, summary].compress.join delimiter

      def labeled_version = "#{label} #{version}"

      def named_version = "#{name} #{version}"

      def package_path = Pathname("tmp").join package_name

      def package_name = "#{name}-#{version}.gem"

      def source_path = Pathname record.full_gem_path

      def version = Version record.version.to_s

      private

      attr_reader :record
    end
  end
end
