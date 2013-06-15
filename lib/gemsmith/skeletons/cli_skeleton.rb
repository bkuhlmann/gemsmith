module Gemsmith
  module Skeletons
    class CLISkeleton < BaseSkeleton
      def create_files
        template File.join("bin", "gem.tmp"), File.join(install_path, "bin", gem_name), template_options
        template File.join("lib", "gem", "cli.rb.tmp"), File.join(lib_install_path, gem_name, "cli.rb"), template_options
      end
    end
  end
end
