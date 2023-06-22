# frozen_string_literal: true

require "sod"

module Gemsmith
  module CLI
    module Actions
      # Stores CLI flag.
      class CLI < Sod::Action
        include Import[:input]

        description "Add command line interface."

        on "--[no-]cli"

        default { Container[:configuration].build_cli }

        def call(value = nil) = input.build_cli = value
      end
    end
  end
end
