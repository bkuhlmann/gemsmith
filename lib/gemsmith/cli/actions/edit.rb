# frozen_string_literal: true

require "dry/monads"
require "sod"
require "spek"

module Gemsmith
  module CLI
    module Actions
      # Handles the edit action for editing an installed gem.
      class Edit < Sod::Action
        include Gemsmith::Import[:kernel, :logger]
        include Dry::Monads[:result]

        description "Edit installed gem in default editor."

        on %w[-e --edit], argument: "GEM"

        def initialize(picker: Spek::Picker, editor: Tools::Editor.new, **)
          super(**)
          @picker = picker
          @editor = editor
        end

        def call gem_name
          case picker.call(gem_name).bind { |spec| editor.call spec }
            in Success(spec) then logger.info { "Editing: #{spec.named_version}." }
            in Failure(message) then log_error { message }
            else log_error { "Unable to handle edit action." }
          end
        end

        private

        attr_reader :picker, :editor

        def log_error(&) = logger.error(&)
      end
    end
  end
end
