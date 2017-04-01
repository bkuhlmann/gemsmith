# frozen_string_literal: true

require "tocer"

module Gemsmith
  module Generators
    # Generates documentation support.
    class Documentation < Base
      def create_files
        cli.template "%gem_name%/README.md.tt", configuration
        cli.template "%gem_name%/CONTRIBUTING.md.tt", configuration
        cli.template "%gem_name%/CODE_OF_CONDUCT.md.tt", configuration
        cli.template "%gem_name%/LICENSE.md.tt", configuration
        cli.template "%gem_name%/CHANGES.md.tt", configuration
      end

      def update_readme
        readme = File.join gem_root, "README.md"
        Tocer::Writer.new(readme).write
      end

      def run
        create_files
        update_readme
      end
    end
  end
end
