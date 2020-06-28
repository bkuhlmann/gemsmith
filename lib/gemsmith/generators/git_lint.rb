# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Git Lint support.
    class GitLint < Base
      def run
        return if configuration.dig :generate, :git_lint

        cli.gsub_file "#{gem_name}/Rakefile", %r(require.+git/lint.+\n), ""
      end
    end
  end
end
