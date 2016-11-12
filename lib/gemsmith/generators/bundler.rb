# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Bundler support.
    class Bundler < Base
      def run
        Dir.chdir(cli.destination_root) do
          cli.info "Installing gem dependencies..."
          `bundle install`
        end
      end
    end
  end
end
