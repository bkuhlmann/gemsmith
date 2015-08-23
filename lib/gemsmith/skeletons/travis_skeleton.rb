module Gemsmith
  module Skeletons
    # Configures Travis CI support.
    class TravisSkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/.travis.yml.tt", template_options
      end
    end
  end
end
