# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates SCSS Lint support.
    class SCSSLint < Base
      def run
        return unless configuration.dig(:generate, :scss_lint)

        gem_name = configuration.dig :gem, :name
        cli.uncomment_lines "#{gem_name}/Rakefile", /require.+scss.+/
        cli.uncomment_lines "#{gem_name}/Rakefile", /SCSSLint.+/
      end
    end
  end
end
