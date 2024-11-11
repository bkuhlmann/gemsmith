# frozen_string_literal: true

require "sod"

module Gemsmith
  module CLI
    module Actions
      # Stores CLI flag.
      class CLI < Sod::Action
        include Dependencies[:settings]

        description "Add command line interface."

        on "--[no-]cli"

        default { Container[:settings].build_cli }

        def call(value) = settings.build_cli = value
      end
    end
  end
end
