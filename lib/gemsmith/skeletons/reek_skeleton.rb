# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures Reek support.
    class ReekSkeleton < BaseSkeleton
      def create
        return unless configuration.dig(:generate, :reek)
        cli.template "%gem_name%/lib/tasks/reek.rake.tt", configuration
      end
    end
  end
end
