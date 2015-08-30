module Gemsmith
  module Skeletons
    # Configures Travis CI support.
    class TravisSkeleton < BaseSkeleton
      def enabled?
        cli.template_options.key?(:travis) && cli.template_options[:travis]
      end

      def create
        return unless enabled?
        cli.template "%gem_name%/.travis.yml.tt", cli.template_options
      end
    end
  end
end
