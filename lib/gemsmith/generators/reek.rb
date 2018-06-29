# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Reek support.
    class Reek < Base
      def run
        return unless configuration.dig(:generate, :reek)

        cli.uncomment_lines "#{gem_name}/Rakefile", /require.+reek.+/
        cli.uncomment_lines "#{gem_name}/Rakefile", /Reek.+/
        template "%gem_name%/.reek.yml.tt"
      end
    end
  end
end
