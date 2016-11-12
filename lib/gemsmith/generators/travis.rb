# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Travis CI support.
    class Travis < Base
      def run
        return unless configuration.dig(:generate, :travis)
        cli.template "%gem_name%/.travis.yml.tt", configuration
      end
    end
  end
end
