# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Reek support.
    class Reek < Base
      def run
        return unless configuration.dig(:generate, :reek)

        gem_name = configuration.dig :gem, :name
        cli.uncomment_lines "#{gem_name}/Rakefile", /require.+reek.+/
        cli.uncomment_lines "#{gem_name}/Rakefile", /Reek.+/
      end
    end
  end
end
