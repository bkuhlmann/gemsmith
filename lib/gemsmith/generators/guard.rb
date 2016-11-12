# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Guard support.
    class Guard < Base
      def run
        return unless configuration.dig(:generate, :guard)
        cli.template "%gem_name%/Guardfile.tt", configuration
      end
    end
  end
end
