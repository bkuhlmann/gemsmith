module Gemsmith
  module Skeletons
    class CoverallsSkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/.coveralls.yml.tt", template_options
      end
    end
  end
end
