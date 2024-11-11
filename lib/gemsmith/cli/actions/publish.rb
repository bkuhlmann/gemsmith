# frozen_string_literal: true

require "dry/monads"
require "pathname"
require "sod"
require "spek"

module Gemsmith
  module CLI
    module Actions
      # Handles the publish action.
      class Publish < Sod::Action
        include Dependencies[:logger]
        include Dry::Monads[:result]

        description "Publish gem to remote gem server."

        ancillary "Optionally computes gem package based on current directory."

        on %w[-p --publish], argument: "[GEM]"

        default { Pathname.pwd.basename }

        def initialize(publisher: Tools::Publisher.new, loader: Spek::Loader, **)
          super(**)
          @publisher = publisher
          @loader = loader
        end

        def call name = default
          case publisher.call loader.call("#{name}.gemspec")
            in Success(spec) then logger.info { "Published: #{spec.package_name}." }
            in Failure(message) then log_error message
            else log_error "Publish failed, unable to parse result."
          end
        end

        private

        attr_reader :publisher, :loader

        def log_error(message) = logger.error { message }
      end
    end
  end
end
