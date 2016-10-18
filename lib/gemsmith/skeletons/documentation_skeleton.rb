# frozen_string_literal: true

require "tocer"

module Gemsmith
  module Skeletons
    # Configures documentation support.
    class DocumentationSkeleton < BaseSkeleton
      def create_files
        cli.template "%gem_name%/README.md.tt", configuration.to_h
        cli.template "%gem_name%/CONTRIBUTING.md.tt", configuration.to_h
        cli.template "%gem_name%/CODE_OF_CONDUCT.md.tt", configuration.to_h
        cli.template "%gem_name%/LICENSE.md.tt", configuration.to_h
        cli.template "%gem_name%/CHANGES.md.tt", configuration.to_h
      end

      def update_readme
        file = File.join cli.destination_root, configuration.gem_name, "README.md"
        Tocer::Writer.new(file).write
      end

      def create
        create_files
        update_readme
      end
    end
  end
end
