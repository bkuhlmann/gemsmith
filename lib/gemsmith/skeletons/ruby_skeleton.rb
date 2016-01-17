# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures Ruby support.
    class RubySkeleton < BaseSkeleton
      def create
        cli.template "%gem_name%/.ruby-version.tt", configuration.to_h
      end
    end
  end
end
