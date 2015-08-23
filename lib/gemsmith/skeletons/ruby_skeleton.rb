module Gemsmith
  module Skeletons
    class RubySkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/.ruby-version.tt", template_options
      end
    end
  end
end
