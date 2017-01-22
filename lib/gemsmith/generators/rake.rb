# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Rake support.
    class Rake < Base
      def run
        cli.template "%gem_name%/Rakefile.tt", configuration
        configure_rakefile
      end

      private

      def rspec_task
        "spec" if configuration.dig(:generate, :rspec)
      end

      def reek_task
        "reek" if configuration.dig(:generate, :reek)
      end

      def rubocop_task
        "rubocop" if configuration.dig(:generate, :rubocop)
      end

      def scss_lint_task
        "scss_lint" if configuration.dig(:generate, :scss_lint)
      end

      def default_tasks
        [rspec_task, reek_task, rubocop_task, scss_lint_task].compact
      end

      def configure_rakefile
        return if default_tasks.empty?
        cli.append_to_file "%gem_name%/Rakefile",
                           %(\ntask default: %w[#{default_tasks.join(" ")}]\n)
      end
    end
  end
end
