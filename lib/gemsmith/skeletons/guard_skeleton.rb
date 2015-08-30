module Gemsmith
  module Skeletons
    # Configures Guard support.
    class GuardSkeleton < BaseSkeleton
      def create
        cli.template "%gem_name%/Guardfile.tt", cli.template_options
      end
    end
  end
end
