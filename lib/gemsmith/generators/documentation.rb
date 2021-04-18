# frozen_string_literal: true

require "tocer"

module Gemsmith
  module Generators
    # Generates documentation support.
    class Documentation < Base
      def initialize cli, configuration: {}, writer: Tocer::Writer.new
        super cli, configuration: configuration
        @writer = writer
      end

      def run
        create_files
        update_readme
      end

      private

      attr_reader :writer

      def create_files
        template "%gem_name%/README.md.tt"
        template "%gem_name%/CONTRIBUTING.md.tt"
        template "%gem_name%/CODE_OF_CONDUCT.md.tt"
        template "%gem_name%/LICENSE.md.tt"
        template "%gem_name%/CHANGES.md.tt"
      end

      def update_readme
        gem_root.join("README.md").then { |path| writer.call path }
      end
    end
  end
end
