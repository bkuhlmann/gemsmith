# frozen_string_literal: true

module Gemsmith
  module Generators
    # Configures Travis CI support.
    class Travis < Base
      def create
        return unless configuration.dig(:generate, :travis)
        cli.template "%gem_name%/.travis.yml.tt", configuration
      end
    end
  end
end
