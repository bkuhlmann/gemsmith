# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Circle CI support.
    class CircleCI < Base
      def run
        return unless configuration.dig(:generate, :circle_ci)

        template "%gem_name%/circle.yml.tt"
      end
    end
  end
end
