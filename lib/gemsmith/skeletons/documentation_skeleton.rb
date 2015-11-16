require "tocer"

module Gemsmith
  module Skeletons
    # Configures documentation support.
    class DocumentationSkeleton < BaseSkeleton
      def create_files
        cli.template "%gem_name%/README.md.tt", cli.template_options
        cli.template "%gem_name%/CONTRIBUTING.md.tt", cli.template_options
        cli.template "%gem_name%/CODE_OF_CONDUCT.md.tt", cli.template_options
        cli.template "%gem_name%/LICENSE.md.tt", cli.template_options
        cli.template "%gem_name%/CHANGELOG.md.tt", cli.template_options
      end

      def update_readme
        file = File.join cli.destination_root, cli.gem_name, "README.md"
        Tocer::Writer.new(file).write
      end

      def create
        create_files
        update_readme
      end
    end
  end
end
