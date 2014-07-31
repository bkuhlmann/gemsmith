module Gemsmith
  module Skeletons
    class GuardSkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/Guardfile.tt", template_options
      end
    end
  end
end
