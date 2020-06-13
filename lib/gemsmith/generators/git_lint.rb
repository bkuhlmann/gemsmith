# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Git Lint support.
    class GitLint < Base
      def run
        return unless configuration.dig :generate, :git_lint

        cli.uncomment_lines "#{gem_name}/Rakefile", %r(require.+git/lint.+)
      end
    end
  end
end
