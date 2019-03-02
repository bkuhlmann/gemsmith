# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Bundler Audit support.
    class BundlerAudit < Base
      def run
        return unless configuration.dig :generate, :bundler_audit

        cli.uncomment_lines "#{gem_name}/Rakefile", %r(require.+bundler\/audit.+)
        cli.uncomment_lines "#{gem_name}/Rakefile", /Bundler\:\:Audit.+/
      end
    end
  end
end
