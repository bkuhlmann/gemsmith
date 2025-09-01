# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    # Builds project skeleton with Gemfile configuration.
    class Bundler < Rubysmith::Builders::Bundler
      using Refinements::Struct

      def call
        super

        builder.call(settings.with(template_path: "%project_name%/Gemfile.erb"))
               .insert_after("source", "\ngemspec\n")
               .replace(/spec\n\n\Z/m, "spec\n")
               .replace(/.+(dry-monads|refinements|zeitwerk).+/, "")
               .replace(/"\s+group/m, %("\n\ngroup))
               .replace("\n\n\n\n", "\n")

        true
      end
    end
  end
end
