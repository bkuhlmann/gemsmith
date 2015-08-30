module Gemsmith
  module Skeletons
    # Configures Rubocop support.
    class RubocopSkeleton < BaseSkeleton
      def create
        cli.template "%gem_name%/.rubocop.yml.tt", cli.template_options
        cli.template "%gem_name%/lib/%gem_name%/tasks/rubocop.rake.tt", cli.template_options
      end
    end
  end
end
