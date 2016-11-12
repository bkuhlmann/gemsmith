# frozen_string_literal: true

module Gemsmith
  module Generators
    # Configures Reek support.
    class Reek < Base
      def create
        return unless configuration.dig(:generate, :reek)
        cli.template "%gem_name%/lib/tasks/reek.rake.tt", configuration
      end
    end
  end
end
