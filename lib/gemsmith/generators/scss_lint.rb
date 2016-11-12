# frozen_string_literal: true

module Gemsmith
  module Generators
    # Configures SCSS Lint support.
    class SCSSLint < Base
      def create
        return unless configuration.dig(:generate, :scss_lint)
        cli.template "%gem_name%/lib/tasks/scss_lint.rake.tt", configuration
      end
    end
  end
end
