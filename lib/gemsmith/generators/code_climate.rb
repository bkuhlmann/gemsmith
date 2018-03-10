# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Code Climate support.
    class CodeClimate < Base
      def run
        return unless configuration.dig(:generate, :code_climate)
        template "%gem_name%/.codeclimate.yml.tt"
      end
    end
  end
end
