module Gemsmith
  module Skeletons
    # Configures Rubocop support.
    class RubocopSkeleton < BaseSkeleton
      def enabled?
        cli.template_options.key?(:rubocop) && cli.template_options[:rubocop]
      end

      def create
        return unless enabled?

        cli.template "%gem_name%/.rubocop.yml.tt", cli.template_options
        cli.template "%gem_name%/lib/%gem_name%/tasks/rubocop.rake.tt", cli.template_options
      end
    end
  end
end
