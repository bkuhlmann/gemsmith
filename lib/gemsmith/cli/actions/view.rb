# frozen_string_literal: true

require "dry/monads"
require "spek"

module Gemsmith
  module CLI
    module Actions
      # Handles the view action for viewing an installed gem in default browser.
      class View
        include Import[:kernel, :logger]
        include Dry::Monads[:result]

        def initialize picker: Spek::Picker, viewer: Tools::Viewer.new, **dependencies
          super(**dependencies)

          @picker = picker
          @viewer = viewer
        end

        def call gem_name
          case picker.call(gem_name).bind { |spec| viewer.call spec }
            in Success(spec) then logger.info { "Viewing: #{spec.named_version}." }
            in Failure(message) then error { message }
            else error { "Unable to handle view action." }
          end
        end

        private

        attr_reader :picker, :viewer

        def error(&) = logger.error(&)
      end
    end
  end
end
