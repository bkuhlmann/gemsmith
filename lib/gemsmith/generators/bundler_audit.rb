# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Bundler Audit support.
    class BundlerAudit < Base
      def run
        return if configuration.dig :generate, :bundler_audit

        cli.gsub_file "#{gem_name}/Rakefile", %r(require.+bundler/audit.+\n), ""
        cli.gsub_file "#{gem_name}/Rakefile", /Bundler::Audit.+\n/, ""
      end
    end
  end
end
