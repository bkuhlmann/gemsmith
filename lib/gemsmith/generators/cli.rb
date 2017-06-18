# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Command Line Interface (CLI) support.
    class CLI < Base
      # rubocop:disable Metrics/AbcSize
      def run
        return unless configuration.dig(:generate, :cli)

        cli.template "%gem_name%/bin/%gem_name%.tt", configuration
        cli.template "%gem_name%/lib/%gem_path%/cli.rb.tt", configuration
        cli.template "%gem_name%/spec/lib/%gem_path%/cli_spec.rb.tt", configuration
        cli.chmod "#{gem_name}/bin/#{gem_name}", 0o755
      end
    end
  end
end
