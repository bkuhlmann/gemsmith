# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures Guard support.
    class GuardSkeleton < BaseSkeleton
      def create
        return unless configuration.dig(:create, :guard)
        cli.template "%gem_name%/Guardfile.tt", configuration
      end
    end
  end
end
