module Gemsmith
  module Skeletons
    # Configures Bundler support.
    class BundlerSkeleton < BaseSkeleton
      def create
        Dir.chdir(File.join(cli.destination_root, cli.gem_name)) do
          cli.info "Installing gem dependencies..."
          `bundle install`
        end
      end
    end
  end
end
