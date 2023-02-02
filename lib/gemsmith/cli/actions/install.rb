# frozen_string_literal: true

require "dry/monads"
require "spek"

module Gemsmith
  module CLI
    module Actions
      # Handles the install action.
      class Install
        include Gemsmith::Import[:logger]
        include Dry::Monads[:result]

        def initialize(installer: Tools::Installer.new, loader: Spek::Loader, **)
          super(**)
          @installer = installer
          @loader = loader
        end

        def call configuration
          case installer.call loader.call("#{configuration.project_name}.gemspec")
            in Success(spec) then logger.info { "Installed: #{spec.package_name}." }
            in Failure(message) then error { message }
            else error { "Unable to handle install action." }
          end
        end

        private

        attr_reader :installer, :loader

        def error(&) = logger.error(&)
      end
    end
  end
end
