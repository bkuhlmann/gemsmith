module Gemsmith
  module Skeletons
    # Configures documentation support.
    class DocumentationSkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/README.md.tt", template_options
        template "%gem_name%/CONTRIBUTING.md.tt", template_options
        template "%gem_name%/CODE_OF_CONDUCT.md.tt", template_options
        template "%gem_name%/LICENSE.md.tt", template_options
        template "%gem_name%/CHANGELOG.md.tt", template_options
      end
    end
  end
end
