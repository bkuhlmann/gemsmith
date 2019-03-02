# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Bundler support.
    class Bundler < Base
      def run
        Dir.chdir gem_root do
          cli.say_status :info, "Installing gem dependencies...", :green
          cli.run "bundle install"
        end
      end
    end
  end
end
