# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Ruby support.
    class Ruby < Base
      def run
        template "%gem_name%/.ruby-version.tt"
      end
    end
  end
end
