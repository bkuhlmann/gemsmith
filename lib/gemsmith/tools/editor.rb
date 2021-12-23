# frozen_string_literal: true

require "dry/monads"

module Gemsmith
  module Tools
    # Edits a gem within default editor.
    class Editor
      include Dry::Monads[:result]

      def initialize container: Container
        @container = container
      end

      def call specification
        executor.capture3(client, specification.source_path.to_s).then do |_stdout, stderr, status|
          status.success? ? Success(specification) : Failure(stderr)
        end
      end

      private

      attr_reader :container

      def executor = container[__method__]

      def client = container[:environment].fetch("EDITOR")
    end
  end
end
