module Gemsmith
  module Skeletons
    class TravisSkeleton < BaseSkeleton
      def create_files
        template "travis.yml.tmp", File.join(install_path, ".travis.yml"), template_options
      end
    end
  end
end
