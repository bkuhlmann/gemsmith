# frozen_string_literal: true

require "dry/monads"
require "spek"

module Gemsmith
  module CLI
    module Actions
      # Handles the edit action for editing an installed gem.
      class Edit
        include Gemsmith::Import[:kernel, :logger]
        include Dry::Monads[:result]

        def initialize picker: Spek::Picker, editor: Tools::Editor.new, **dependencies
          super(**dependencies)

          @picker = picker
          @editor = editor
        end

        def call gem_name
          case picker.call(gem_name).bind { |spec| editor.call spec }
            in Success(spec) then logger.info { "Editing: #{spec.named_version}." }
            in Failure(message) then error { message }
            else error { "Unable to handle edit action." }
          end
        end

        private

        attr_reader :picker, :editor

        def error(&) = logger.error(&)
      end
    end
  end
end
