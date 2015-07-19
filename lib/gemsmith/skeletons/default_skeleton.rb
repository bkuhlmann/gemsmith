module Gemsmith
  module Skeletons
    class DefaultSkeleton < BaseSkeleton
      def create_default_files
        template "%gem_name%/Gemfile.tt", template_options
        template "%gem_name%/Rakefile.tt", template_options
        template "%gem_name%/%gem_name%.gemspec.tt", template_options
        template "#{lib_root}/%gem_name%.rb.tt", template_options
        template "#{lib_root}/%gem_name%/identity.rb.tt", template_options
      end

      def create_ruby_files
        template "%gem_name%/.ruby-version.tt", template_options
      end

      def create_git_files
        template "%gem_name%/.gitignore.tt", template_options
      end
    end
  end
end
