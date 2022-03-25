# frozen_string_literal: true

require "dry/monads"
require "spek"

module Gemsmith
  module CLI
    module Actions
      # Handles the publish action.
      class Publish
        include Gemsmith::Import[:logger]
        include Dry::Monads[:result]

        def initialize publisher: Tools::Publisher.new, loader: Spek::Loader, **dependencies
          super(**dependencies)

          @publisher = publisher
          @loader = loader
        end

        def call configuration
          case publisher.call loader.call("#{configuration.project_name}.gemspec")
            in Success(spec) then logger.info { "Published: #{spec.package_name}." }
            in Failure(message) then error { message }
            else error { "Unable to handle publish action." }
          end
        end

        private

        attr_reader :publisher, :loader

        def error(&) = logger.error(&)
      end
    end
  end
end
