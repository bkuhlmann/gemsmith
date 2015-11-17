module Gemsmith
  module Skeletons
    # Configures Command Line Interface (CLI) support.
    class CLISkeleton < BaseSkeleton
      def create
        return unless configuration.create_cli?

        cli.template "%gem_name%/bin/%gem_name%.tt", configuration.to_h
        cli.template "%gem_name%/lib/%gem_name%/cli.rb.tt", configuration.to_h
      end
    end
  end
end
