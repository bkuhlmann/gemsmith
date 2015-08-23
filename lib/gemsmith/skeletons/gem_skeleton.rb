module Gemsmith
  module Skeletons
    # Configures default gem support.
    class GemSkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/Gemfile.tt", template_options
        template "%gem_name%/%gem_name%.gemspec.tt", template_options
        template "#{lib_root}/%gem_name%.rb.tt", template_options
        template "#{lib_root}/%gem_name%/identity.rb.tt", template_options
      end
    end
  end
end
