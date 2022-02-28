# frozen_string_literal: true

require "dry/monads"

module Gemsmith
  module Tools
    # Edits a gem within default editor.
    class Editor
      include Import[:executor, :environment]
      include Dry::Monads[:result]

      def call specification
        executor.capture3(client, specification.source_path.to_s).then do |_stdout, stderr, status|
          status.success? ? Success(specification) : Failure(stderr)
        end
      end

      private

      def client = environment.fetch("EDITOR")
    end
  end
end
