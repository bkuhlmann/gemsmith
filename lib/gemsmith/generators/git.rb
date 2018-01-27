# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Git support.
    class Git < Base
      def create_ignore_file
        cli.template "%gem_name%/.gitignore.tt", configuration
      end

      # :reek:TooManyStatements
      def create_repository
        subject = "Added Gemsmith skeleton."
        body = "Built with #{Identity.version_label}."

        Dir.chdir(gem_root) do
          `git init`
          `git add .`
          `git commit --all --no-verify --message "#{subject}" --message "#{body}"`
        end
      end

      def run
        create_ignore_file
        create_repository
      end
    end
  end
end
