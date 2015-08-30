module Gemsmith
  module Skeletons
    # Configures documentation support.
    class DocumentationSkeleton < BaseSkeleton
      def create
        cli.template "%gem_name%/README.md.tt", cli.template_options
        cli.template "%gem_name%/CONTRIBUTING.md.tt", cli.template_options
        cli.template "%gem_name%/CODE_OF_CONDUCT.md.tt", cli.template_options
        cli.template "%gem_name%/LICENSE.md.tt", cli.template_options
        cli.template "%gem_name%/CHANGELOG.md.tt", cli.template_options
      end
    end
  end
end
