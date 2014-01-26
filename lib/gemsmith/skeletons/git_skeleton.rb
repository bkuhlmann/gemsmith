module Gemsmith
  module Skeletons
    class GitSkeleton < BaseSkeleton
      def create_files
        Dir.chdir(File.join(destination_root, gem_name)) do
          `git init`
          `git add .`
          `git commit -a -n -m "Added Gemsmith skeleton."`
        end
      end
    end
  end
end
