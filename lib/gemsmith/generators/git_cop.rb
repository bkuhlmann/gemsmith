# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Git Cop support.
    class GitCop < Base
      def run
        return unless configuration.dig :generate, :git_cop

        warn "[DEPRECATION]: Git Cop is deprecated, use Git Lint instead."
      end
    end
  end
end
