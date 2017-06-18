# frozen_string_literal: true

require "refinements/arrays"

module Gemsmith
  module Generators
    # Generates Rake support.
    class Rake < Base
      using Refinements::Arrays

      def generate_code_quality_task
        return "" if code_quality_tasks.empty?
        %(\ndesc "Run code quality checks"\ntask code_quality: %i[#{code_quality_tasks}]\n)
      end

      def generate_default_task
        return "" if default_task.empty?
        %(\ntask default: %i[#{default_task}]\n)
      end

      def run
        cli.template "%gem_name%/Rakefile.tt", configuration
        append_code_quality_task
        append_default_task
      end

      private

      def rspec_task
        configuration.dig(:generate, :rspec) ? "spec" : ""
      end

      def git_cop_task
        configuration.dig(:generate, :git_cop) ? "git_cop" : ""
      end

      def reek_task
        configuration.dig(:generate, :reek) ? "reek" : ""
      end

      def rubocop_task
        configuration.dig(:generate, :rubocop) ? "rubocop" : ""
      end

      def scss_lint_task
        configuration.dig(:generate, :scss_lint) ? "scss_lint" : ""
      end

      def code_quality_tasks
        [git_cop_task, reek_task, rubocop_task, scss_lint_task].compress.join " "
      end

      def code_quality_task
        code_quality_tasks.empty? ? "" : "code_quality"
      end

      def default_task
        [code_quality_task, rspec_task].compress.join " "
      end

      def append_code_quality_task
        return if code_quality_task.empty?
        cli.append_to_file "%gem_name%/Rakefile", generate_code_quality_task
      end

      def append_default_task
        return if default_task.empty?
        cli.append_to_file "%gem_name%/Rakefile", generate_default_task
      end
    end
  end
end
