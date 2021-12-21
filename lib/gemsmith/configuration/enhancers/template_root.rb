# frozen_string_literal: true

module Gemsmith
  module Configuration
    module Enhancers
      # Adds gem specific roots to existing content.
      class TemplateRoot
        def initialize overrides = Pathname(__dir__).join("../../templates")
          @overrides = Array overrides
        end

        def call(content) = content.add_template_roots(overrides)

        private

        attr_reader :overrides
      end
    end
  end
end
