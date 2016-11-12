# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates SCSS Lint support.
    class SCSSLint < Base
      def run
        return unless configuration.dig(:generate, :scss_lint)
        cli.template "%gem_name%/lib/tasks/scss_lint.rake.tt", configuration
      end
    end
  end
end
