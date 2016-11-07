# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures Command Line Interface (CLI) support.
    class CLISkeleton < BaseSkeleton
      def create
        return unless configuration.dig(:create, :cli)

        cli.template "%gem_name%/bin/%gem_name%.tt", configuration
        cli.template "%gem_name%/lib/%gem_path%/cli.rb.tt", configuration
        cli.template "%gem_name%/spec/lib/%gem_path%/cli_spec.rb.tt", configuration
        cli.chmod "#{configuration.dig :gem, :name}/bin/#{configuration.dig :gem, :name}", 0o755
      end
    end
  end
end
