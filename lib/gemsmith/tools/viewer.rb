# frozen_string_literal: true

require "dry/monads"

module Gemsmith
  module Tools
    # Views a gem within default browser.
    class Viewer
      include Dry::Monads[:result]

      def initialize container: Container
        @container = container
      end

      def call specification
        executor.capture3("open", specification.homepage_url).then do |_stdout, stderr, status|
          status.success? ? Success(specification) : Failure(stderr)
        end
      end

      private

      attr_reader :container

      def executor = container[__method__]
    end
  end
end
