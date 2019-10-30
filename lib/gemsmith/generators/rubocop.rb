# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Rubocop support.
    class Rubocop < Base
      def run
        return unless configuration.dig :generate, :rubocop

        cli.uncomment_lines "#{gem_name}/Rakefile", /require.+rubocop.+/
        cli.uncomment_lines "#{gem_name}/Rakefile", /RuboCop.+/
        template "%gem_name%/.rubocop.yml.tt"
        cli.run "cd #{gem_name} && bundle exec rubocop --auto-correct > /dev/null"
      end
    end
  end
end
