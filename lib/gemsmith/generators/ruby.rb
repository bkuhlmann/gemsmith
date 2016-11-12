# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Ruby support.
    class Ruby < Base
      def run
        cli.template "%gem_name%/.ruby-version.tt", configuration
      end
    end
  end
end
