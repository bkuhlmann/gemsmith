# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Rubocop support.
    class Rubocop < Base
      def run
        if configuration.dig :generate, :rubocop
          template "%gem_name%/.rubocop.yml.tt"
          cli.run "cd #{gem_name} && bundle exec rubocop --auto-correct > /dev/null"
        else
          cli.gsub_file "#{gem_name}/Rakefile", /require.+rubocop.+\n/, ""
          cli.gsub_file "#{gem_name}/Rakefile", /RuboCop.+\n/, ""
        end
      end
    end
  end
end
