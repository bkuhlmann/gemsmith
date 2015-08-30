module Gemsmith
  module Skeletons
    # Configures Command Line Interface (CLI) support.
    class CLISkeleton < BaseSkeleton
      def enabled?
        cli.template_options.key?(:bin) && cli.template_options[:bin]
      end

      def create
        return unless enabled?

        cli.template "%gem_name%/bin/%gem_name%.tt", cli.template_options
        cli.template "%gem_name%/lib/%gem_name%/cli.rb.tt", cli.template_options
      end
    end
  end
end
