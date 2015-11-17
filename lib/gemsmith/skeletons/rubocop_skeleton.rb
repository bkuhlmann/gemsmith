module Gemsmith
  module Skeletons
    # Configures Rubocop support.
    class RubocopSkeleton < BaseSkeleton
      def create
        return unless configuration.create_rubocop?

        cli.template "%gem_name%/.rubocop.yml.tt", configuration.to_h
        cli.template "%gem_name%/lib/%gem_name%/tasks/rubocop.rake.tt", configuration.to_h
      end
    end
  end
end
