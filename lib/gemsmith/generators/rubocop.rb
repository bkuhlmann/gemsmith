# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Rubocop support.
    class Rubocop < Base
      def run
        return unless configuration.dig(:generate, :rubocop)

        gem_name = configuration.dig :gem, :name

        cli.uncomment_lines "#{gem_name}/Rakefile", /require.+rubocop.+/
        cli.uncomment_lines "#{gem_name}/Rakefile", /RuboCop.+/
        cli.template "%gem_name%/.rubocop.yml.tt", configuration
        cli.run "rubocop --auto-correct > /dev/null"
      end
    end
  end
end
