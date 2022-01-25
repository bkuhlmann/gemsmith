# frozen_string_literal: true

require "refinements/structs"

module Gemsmith
  module Builders
    # Builds project skeleton with Gemfile configuration.
    class Bundler
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Rubysmith::Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        builder.call(configuration.merge(template_path: "%project_name%/Gemfile.erb"))
               .insert_after("source", "\ngemspec\n")
               .replace(/spec\n\n\Z/m, "spec\n")
               .replace(/.+refinements.+/, "")
               .replace(/.+zeitwerk.+/, "")
               .replace("\n\n\n\n", "\n")

        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
