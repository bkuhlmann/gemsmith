module Gemsmith
  module Skeletons
    class GitSkeleton < BaseSkeleton
      def create_files
        Dir.chdir(install_path) do
          `git init`
          `git add .`
          `git commit -a -n -m "Gemsmith skeleton created."`
        end
      end
    end
  end
end
