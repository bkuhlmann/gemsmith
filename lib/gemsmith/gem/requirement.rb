# frozen_string_literal: true

require "versionaire"

module Gemsmith
  module Gem
    # Defines a gem requirement. This is a partial, cleaner implementation of the RubyGems
    # `Gem::Requirement` object.
    # :reek:MissingSafeMethod
    class Requirement
      def self.operators
        [">", ">=", "=", "!=", "<", "<=", "~>"]
      end

      def self.version_segments version
        String(version).split(Versionaire::VERSION_DELIMITER).map(&:to_i)
      end

      def self.for object
        case object
          when String
            operator, version = object.split " "
            new operator: operator, raw_version: version
          else
            fail Errors::RequirementConversion,
                 %(Invalid string conversion. Use: "<operator> <version>".)
        end
      end

      attr_reader :operator, :raw_version, :version_segments, :version

      def initialize operator: ">=", raw_version: "0"
        @operator = operator
        @raw_version = raw_version
        @version_segments = self.class.version_segments raw_version
        @version = Versionaire::Version version_segments
        validate!
      end

      def to_s
        "#{operator} #{version}"
      end

      private

      def validate!
        operators = self.class.operators
        return true if operators.include? operator

        fail Errors::RequirementOperator,
             %(Invalid gem requirement operator. Use: #{operators.join ", "}.)
      end
    end
  end
end
