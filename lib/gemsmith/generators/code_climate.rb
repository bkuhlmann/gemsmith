# frozen_string_literal: true

module Gemsmith
  module Generators
    # Configures Code Climate support.
    class CodeClimate < Base
      def create
        return unless configuration.dig(:generate, :code_climate)

        cli.template "%gem_name%/.codeclimate.yml.tt", configuration
      end
    end
  end
end
