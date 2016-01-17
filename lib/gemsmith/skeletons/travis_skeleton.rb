# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures Travis CI support.
    class TravisSkeleton < BaseSkeleton
      def create
        return unless configuration.create_travis?
        cli.template "%gem_name%/.travis.yml.tt", configuration.to_h
      end
    end
  end
end
