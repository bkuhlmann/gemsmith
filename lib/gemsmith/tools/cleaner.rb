# frozen_string_literal: true

require "dry/monads"
require "refinements/pathname"

module Gemsmith
  module Tools
    # Cleans gem artifacts.
    class Cleaner
      include Dry::Monads[:result]

      using Refinements::Pathname

      def initialize root_dir: Pathname.pwd
        @root_dir = root_dir
      end

      def call specification
        root_dir.join("pkg").remove_tree
        root_dir.files("**/*.gem").each(&:delete)
        Success specification
      end

      private

      attr_reader :root_dir
    end
  end
end
