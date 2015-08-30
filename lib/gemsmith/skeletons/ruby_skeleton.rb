module Gemsmith
  module Skeletons
    # Configures Ruby support.
    class RubySkeleton < BaseSkeleton
      def create
        cli.template "%gem_name%/.ruby-version.tt", cli.template_options
      end
    end
  end
end
