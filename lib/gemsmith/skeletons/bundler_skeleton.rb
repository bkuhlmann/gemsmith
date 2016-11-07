# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures Bundler support.
    class BundlerSkeleton < BaseSkeleton
      def create
        Dir.chdir(cli.destination_root) do
          cli.info "Installing gem dependencies..."
          `bundle install`
        end
      end
    end
  end
end
