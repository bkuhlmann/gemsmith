module Gemsmith
  module Skeletons
    # Configures default gem support.
    class GemSkeleton < BaseSkeleton
      def create
        cli.template "%gem_name%/Gemfile.tt", cli.template_options
        cli.template "%gem_name%/%gem_name%.gemspec.tt", cli.template_options
        cli.template "#{lib_root}/%gem_name%.rb.tt", cli.template_options
        cli.template "#{lib_root}/%gem_name%/identity.rb.tt", cli.template_options
      end
    end
  end
end
