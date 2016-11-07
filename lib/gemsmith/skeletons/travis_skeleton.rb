# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures Travis CI support.
    class TravisSkeleton < BaseSkeleton
      def create
        return unless configuration.dig(:create, :travis)
        cli.template "%gem_name%/.travis.yml.tt", configuration
      end
    end
  end
end
