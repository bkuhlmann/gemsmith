# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures Guard support.
    class GuardSkeleton < BaseSkeleton
      def create
        return unless configuration.create_guard?
        cli.template "%gem_name%/Guardfile.tt", configuration.to_h
      end
    end
  end
end
