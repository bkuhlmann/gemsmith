# frozen_string_literal: true

require "dry/monads"

module Gemsmith
  module Tools
    # Validates whether a gem can be published or not.
    class Validator
      include Dry::Monads[:result]

      def initialize container: Container
        @container = container
      end

      def call specification
        executor.capture3("git", "status", "--porcelain").then do |_stdout, _stderr, status|
          status.success? ? Success(specification) : Failure("Project has uncommitted changes.")
        end
      end

      private

      attr_reader :container

      def executor = container[__method__]
    end
  end
end
