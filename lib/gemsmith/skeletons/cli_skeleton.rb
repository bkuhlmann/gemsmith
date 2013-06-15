module Gemsmith
  module Skeletons
    class CLISkeleton < BaseSkeleton
      def create_files
        template File.join("bin", "gem.tmp"), File.join(install_path, "bin", gem_name), template_options
        template File.join(gem_source_path, "cli.rb.tmp"), File.join(gem_install_path, "cli.rb"), template_options
      end
    end
  end
end
