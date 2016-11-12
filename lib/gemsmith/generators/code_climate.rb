# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Code Climate support.
    class CodeClimate < Base
      def run
        return unless configuration.dig(:generate, :code_climate)

        cli.template "%gem_name%/.codeclimate.yml.tt", configuration
      end
    end
  end
end
