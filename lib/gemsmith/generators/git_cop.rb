# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Git Cop support.
    class GitCop < Base
      def run
        return unless configuration.dig(:generate, :git_cop)
        cli.uncomment_lines "#{gem_name}/Rakefile", %r(require.+git\/cop.+)
      end
    end
  end
end
