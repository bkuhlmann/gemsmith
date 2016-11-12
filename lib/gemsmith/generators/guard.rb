# frozen_string_literal: true

module Gemsmith
  module Generators
    # Configures Guard support.
    class Guard < Base
      def create
        return unless configuration.dig(:generate, :guard)
        cli.template "%gem_name%/Guardfile.tt", configuration
      end
    end
  end
end
