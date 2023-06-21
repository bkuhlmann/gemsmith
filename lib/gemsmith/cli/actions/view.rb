# frozen_string_literal: true

require "dry/monads"
require "sod"
require "spek"

module Gemsmith
  module CLI
    module Actions
      # Handles the view action for viewing an installed gem in default browser.
      class View < Sod::Action
        include Import[:kernel, :logger]
        include Dry::Monads[:result]

        description "View installed gem in default browser."

        on %w[-V --view], argument: "GEM"

        def initialize(picker: Spek::Picker, viewer: Tools::Viewer.new, **)
          super(**)
          @picker = picker
          @viewer = viewer
        end

        def call gem_name
          case picker.call(gem_name).bind { |spec| viewer.call spec }
            in Success(spec) then logger.info { "Viewing: #{spec.named_version}." }
            in Failure(message) then log_error { message }
            else log_error { "Unable to handle view action." }
          end
        end

        private

        attr_reader :picker, :viewer

        def log_error(&) = logger.error(&)
      end
    end
  end
end
