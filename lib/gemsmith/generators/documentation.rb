# frozen_string_literal: true

require "tocer"

module Gemsmith
  module Generators
    # Generates documentation support.
    class Documentation < Base
      def create_files
        template "%gem_name%/README.md.tt"
        template "%gem_name%/CONTRIBUTING.md.tt"
        template "%gem_name%/CODE_OF_CONDUCT.md.tt"
        template "%gem_name%/LICENSE.md.tt"
        template "%gem_name%/CHANGES.md.tt"
      end

      def update_readme
        readme = File.join gem_root, "README.md"
        Tocer::Writer.new(readme).call
      end

      def run
        create_files
        update_readme
      end
    end
  end
end
