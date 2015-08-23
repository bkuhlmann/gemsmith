module Gemsmith
  module Skeletons
    # Configures Ruby support.
    class RubySkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/.ruby-version.tt", template_options
      end
    end
  end
end
