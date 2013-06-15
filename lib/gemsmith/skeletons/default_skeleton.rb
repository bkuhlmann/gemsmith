module Gemsmith
  module Skeletons
    class DefaultSkeleton < BaseSkeleton
      def create_files
        template "Gemfile.tmp", File.join(install_path, "Gemfile"), template_options
        template "Rakefile.tmp", File.join(install_path, "Rakefile"), template_options
        template "gitignore.tmp", File.join(install_path, ".gitignore"), template_options
        template "ruby-version.tmp", File.join(install_path, ".ruby-version"), template_options
        template "gem.gemspec.tmp", File.join(install_path, "#{gem_name}.gemspec"), template_options
        template File.join("lib", "gem.rb.tmp"), File.join(install_path, "lib", "#{gem_name}.rb"), template_options
        template File.join("lib", "gem", "version.rb.tmp"), File.join(install_path, "lib", gem_name, "version.rb"), template_options
      end
    end
  end
end
