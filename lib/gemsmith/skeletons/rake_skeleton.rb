module Gemsmith
  module Skeletons
    class RakeSkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/Rakefile.tt", template_options
      end
    end
  end
end
