# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    # Builds project skeleton gem specification for use by RubyGems.
    class Specification < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        config = configuration.merge template_path: "%project_name%/%project_name%.gemspec.erb"

        builder.call(config)
               .render
               .replace("    \n", "")
               .replace("      ", "    ")
               .replace("  \n", "")
               .replace("    spec", "  spec")
               .replace(/\}\s+s/m, "}\n\n  s")

        configuration
      end
    end
  end
end
