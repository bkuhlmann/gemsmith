# frozen_string_literal: true

require "dry/monads"

module Gemsmith
  module CLI
    module Actions
      # Handles the publish action.
      class Publish
        include Dry::Monads[:result]

        def initialize publisher: Tools::Publisher.new, loader: Gems::Loader, container: Container
          @publisher = publisher
          @loader = loader
          @container = container
        end

        def call configuration
          case publisher.call loader.call("#{configuration.project_name}.gemspec")
            in Success(spec) then logger.info { "Published: #{spec.package_name}." }
            in Failure(message) then error { message }
            else error { "Unable to handle publish action." }
          end
        end

        private

        attr_reader :publisher, :loader, :container

        def error(&) = logger.error(&)

        def logger = container[__method__]
      end
    end
  end
end
