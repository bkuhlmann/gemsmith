# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures Rubocop support.
    class RubocopSkeleton < BaseSkeleton
      def create
        return unless configuration.dig(:create, :rubocop)

        cli.template "%gem_name%/.rubocop.yml.tt", configuration
        cli.template "%gem_name%/lib/tasks/rubocop.rake.tt", configuration
        cli.run "rubocop --auto-correct > /dev/null"
      end
    end
  end
end
