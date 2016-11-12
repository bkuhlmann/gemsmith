# frozen_string_literal: true

module Gemsmith
  module Generators
    # Configures Bundler support.
    class Bundler < Base
      def create
        Dir.chdir(cli.destination_root) do
          cli.info "Installing gem dependencies..."
          `bundle install`
        end
      end
    end
  end
end
