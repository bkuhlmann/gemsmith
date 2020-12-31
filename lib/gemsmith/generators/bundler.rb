# frozen_string_literal: true

require "refinements/pathnames"

module Gemsmith
  module Generators
    # Generates Bundler support.
    class Bundler < Base
      using Refinements::Pathnames

      def run
        gem_root.change_dir do
          cli.say_status :info, "Installing gem dependencies...", :green
          cli.run "bundle install"
        end
      end
    end
  end
end
