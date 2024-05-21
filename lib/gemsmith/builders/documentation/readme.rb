# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_readme

          builder.call(configuration.merge(template_path: "%project_name%/README.#{kind}.erb"))
                 .replace("Rubysmith", "Gemsmith")
                 .replace("rubysmith", "gemsmith")

          configuration
        end

        private

        def kind = configuration.documentation_format
      end
    end
  end
end
