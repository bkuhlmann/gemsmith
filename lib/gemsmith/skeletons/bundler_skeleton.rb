module Gemsmith
  module Skeletons
    # Configures Bundler support.
    class BundlerSkeleton < BaseSkeleton
      def create_gemfile_lock
        Dir.chdir(File.join(destination_root, gem_name)) do
          info "Installing gem dependencies..."
          `bundle install`
        end
      end
    end
  end
end
