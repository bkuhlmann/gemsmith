# frozen_string_literal: true

require "dry/monads"

module Gemsmith
  module Tools
    # Views a gem within default browser.
    class Viewer
      include Import[:executor]
      include Dry::Monads[:result]

      def call specification
        executor.capture3("open", specification.homepage_url).then do |_stdout, stderr, status|
          status.success? ? Success(specification) : Failure(stderr)
        end
      end
    end
  end
end
