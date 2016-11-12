# frozen_string_literal: true

module Gemsmith
  module Generators
    # Configures Ruby support.
    class Ruby < Base
      def create
        cli.template "%gem_name%/.ruby-version.tt", configuration
      end
    end
  end
end
