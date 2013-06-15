module Gemsmith
  module Skeletons
    class DefaultSkeleton < BaseSkeleton
      def create_default_files
        template "Gemfile.tmp", File.join(install_path, "Gemfile"), template_options
        template "Rakefile.tmp", File.join(install_path, "Rakefile"), template_options
        template "gem.gemspec.tmp", File.join(install_path, "#{gem_name}.gemspec"), template_options
        template File.join("lib", "gem.rb.tmp"), File.join(lib_install_path, "#{gem_name}.rb"), template_options
        template File.join(gem_source_path, "version.rb.tmp"), File.join(gem_install_path, "version.rb"), template_options
      end

      def create_ruby_files
        template "ruby-version.tmp", File.join(install_path, ".ruby-version"), template_options
      end

      def create_git_files
        template "gitignore.tmp", File.join(install_path, ".gitignore"), template_options
      end
    end
  end
end
