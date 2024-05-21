# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    # Builds project skeleton with Gemfile configuration.
    class Bundler < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        builder.call(configuration.merge(template_path: "%project_name%/Gemfile.erb"))
               .insert_after("source", "\ngemspec\n")
               .replace(/spec\n\n\Z/m, "spec\n")
               .replace(/.+refinements.+/, "")
               .replace(/.+zeitwerk.+/, "")
               .replace("\n\n\n\n", "\n")

        configuration
      end
    end
  end
end
