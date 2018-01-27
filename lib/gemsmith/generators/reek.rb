# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Reek support.
    class Reek < Base
      def run
        return unless configuration.dig(:generate, :reek)

        cli.uncomment_lines "#{gem_name}/Rakefile", /require.+reek.+/
        cli.uncomment_lines "#{gem_name}/Rakefile", /Reek.+/
        cli.template "%gem_name%/.reek.tt", configuration
      end
    end
  end
end
