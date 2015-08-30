module Gemsmith
  module Skeletons
    # Configures Travis CI support.
    class TravisSkeleton < BaseSkeleton
      def create
        cli.template "%gem_name%/.travis.yml.tt", cli.template_options
      end
    end
  end
end
