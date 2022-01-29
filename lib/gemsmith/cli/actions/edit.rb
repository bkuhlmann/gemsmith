# frozen_string_literal: true

require "dry/monads"
require "spek"

module Gemsmith
  module CLI
    module Actions
      # Handles the edit action for editing an installed gem.
      class Edit
        include Dry::Monads[:result]

        def initialize picker: Spek::Picker, editor: Tools::Editor.new, container: Container
          @picker = picker
          @editor = editor
          @container = container
        end

        def call gem_name
          case picker.call(gem_name).bind { |spec| editor.call spec }
            in Success(spec) then logger.info { "Editing: #{spec.named_version}." }
            in Failure(message) then error { message }
            else error { "Unable to handle edit action." }
          end
        end

        private

        attr_reader :picker, :editor, :container

        def error(&) = logger.error(&)

        def kernel = container[__method__]

        def logger = container[__method__]
      end
    end
  end
end
