module Gemsmith
  module Skeletons
    # Configures Guard support.
    class GuardSkeleton < BaseSkeleton
      def enabled?
        cli.template_options.key?(:guard) && cli.template_options[:guard]
      end

      def create
        return unless enabled?
        cli.template "%gem_name%/Guardfile.tt", cli.template_options
      end
    end
  end
end
