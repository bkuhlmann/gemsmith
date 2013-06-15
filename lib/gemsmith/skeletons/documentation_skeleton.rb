module Gemsmith
  module Skeletons
    class DocumentationSkeleton < BaseSkeleton
      def create_files
        template "README.md.tmp", File.join(install_path, "README.md"), template_options
        template "CONTRIBUTING.md.tmp", File.join(install_path, "CONTRIBUTING.md"), template_options
        template "LICENSE.md.tmp", File.join(install_path, "LICENSE.md"), template_options
        template "CHANGELOG.md.tmp", File.join(install_path, "CHANGELOG.md"), template_options
      end
    end
  end
end
