module Gemsmith
  module Skeletons
    # Configures Command Line Interface (CLI) support.
    class CLISkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/bin/%gem_name%.tt", template_options
        template "%gem_name%/lib/%gem_name%/cli.rb.tt", template_options
      end
    end
  end
end
