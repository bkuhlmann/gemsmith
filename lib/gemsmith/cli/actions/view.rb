# frozen_string_literal: true

require "dry/monads"

module Gemsmith
  module CLI
    module Actions
      # Handles the view action for viewing an installed gem in default browser.
      class View
        include Dry::Monads[:result]

        def initialize picker: Gems::Picker, viewer: Tools::Viewer.new, container: Container
          @picker = picker
          @viewer = viewer
          @container = container
        end

        def call gem_name
          case picker.call(gem_name).bind { |spec| viewer.call spec }
            in Success(spec) then logger.info { "Viewing: #{spec.named_version}." }
            in Failure(message) then error { message }
            else error { "Unable to handle view action." }
          end
        end

        private

        attr_reader :picker, :viewer, :container

        def error(&) = logger.error(&)

        def kernel = container[__method__]

        def logger = container[__method__]
      end
    end
  end
end
