# frozen_string_literal: true

require "refinements/structs"

module Gemsmith
  module Builders
    # Builds project skeleton gem specification for use by RubyGems.
    class Specification
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Rubysmith::Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        config = configuration.merge template_path: "%project_name%/%project_name%.gemspec.erb"

        builder.call(config)
               .render
               .replace("  \n", "")
               .replace("    spec", "  spec")
               .replace(/\}\s+s/m, "}\n\n  s")

        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
