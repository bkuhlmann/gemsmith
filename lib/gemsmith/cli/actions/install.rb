# frozen_string_literal: true

require "dry/monads"
require "pathname"
require "sod"
require "spek"

module Gemsmith
  module CLI
    module Actions
      # Handles the install action.
      class Install < Sod::Action
        include Import[:logger]
        include Dry::Monads[:result]

        description "Install gem for local development."

        ancillary "Optionally computes gem package based on current directory."

        on %w[-i --install], argument: "[GEM]"

        default { Pathname.pwd.basename }

        def initialize(installer: Tools::Installer.new, loader: Spek::Loader, **)
          super(**)
          @installer = installer
          @loader = loader
        end

        def call name = default
          case installer.call loader.call("#{name}.gemspec")
            in Success(spec) then logger.info { "Installed: #{spec.package_name}." }
            in Failure(message) then log_error { message }
            else log_error { "Unable to handle install action." }
          end
        end

        private

        attr_reader :installer, :loader

        def log_error(&) = logger.error(&)
      end
    end
  end
end
