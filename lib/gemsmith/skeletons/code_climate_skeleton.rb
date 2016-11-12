# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures Code Climate support.
    class CodeClimateSkeleton < BaseSkeleton
      def create
        return unless configuration.dig(:generate, :code_climate)

        cli.template "%gem_name%/.codeclimate.yml.tt", configuration
      end
    end
  end
end
