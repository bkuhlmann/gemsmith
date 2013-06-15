module Gemsmith
  module Skeletons
    class TravisSkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/.travis.yml.tt", template_options
      end
    end
  end
end
