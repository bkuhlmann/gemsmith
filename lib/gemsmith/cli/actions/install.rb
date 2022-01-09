# frozen_string_literal: true

require "dry/monads"

module Gemsmith
  module CLI
    module Actions
      # Handles the install action.
      class Install
        include Dry::Monads[:result]

        def initialize installer: Tools::Installer.new, loader: Gems::Loader, container: Container
          @installer = installer
          @loader = loader
          @container = container
        end

        def call configuration
          case installer.call loader.call("#{configuration.project_name}.gemspec")
            in Success(spec) then logger.info { "Installed: #{spec.package_name}." }
            in Failure(message) then error { message }
            else error { "Unable to handle install action." }
          end
        end

        private

        attr_reader :installer, :loader, :container

        def error(&) = logger.error(&)

        def logger = container[__method__]
      end
    end
  end
end
