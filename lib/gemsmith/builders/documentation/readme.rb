# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme
        using Refinements::Struct

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_readme

          builder.call(configuration.merge(template_path: "%project_name%/README.#{kind}.erb"))
                 .replace("Rubysmith", "Gemsmith")
                 .replace("rubysmith", "gemsmith")

          configuration
        end

        private

        attr_reader :configuration, :builder

        def kind = configuration.documentation_format
      end
    end
  end
end
