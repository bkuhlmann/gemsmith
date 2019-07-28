# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Git support.
    class Git < Base
      def run
        create_ignore_file
        create_repository
      end

      def create_ignore_file
        template "%gem_name%/.gitignore.tt"
      end

      def create_repository
        create_commit "Added gem skeleton.",
                      "Built with [#{Identity.label}](#{Identity.url}) #{Identity.version}."
      end

      private

      def create_commit subject, body
        Dir.chdir gem_root do
          `git init`
          `git add .`
          `git commit --all --no-verify --message "#{subject}" --message "#{body}"`
        end
      end
    end
  end
end
