# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Reek support.
    class Reek < Base
      def run
        return unless configuration.dig(:generate, :reek)
        cli.template "%gem_name%/lib/tasks/reek.rake.tt", configuration
      end
    end
  end
end
