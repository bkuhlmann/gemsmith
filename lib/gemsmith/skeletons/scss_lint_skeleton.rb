# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures SCSS Lint support.
    class SCSSLintSkeleton < BaseSkeleton
      def create
        return unless configuration.dig(:create, :scss_lint)
        cli.template "%gem_name%/lib/tasks/scss_lint.rake.tt", configuration
      end
    end
  end
end
