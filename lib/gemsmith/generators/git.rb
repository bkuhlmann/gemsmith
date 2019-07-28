# frozen_string_literal: true

require "open3"

module Gemsmith
  module Generators
    # Generates Git support.
    class Git < Base
      def initialize cli, configuration: {}, shell: Open3
        super cli, configuration: configuration
        @shell = shell
      end

      def run
        create_ignore_file
        create_repository
      end

      private

      attr_reader :shell

      def create_ignore_file
        template "%gem_name%/.gitignore.tt"
      end

      def create_repository
        create_commit "Added gem skeleton.",
                      "Built with [#{Identity.label}](#{Identity.url}) #{Identity.version}."
      end

      def create_commit subject, body
        Dir.chdir gem_root do
          shell.capture3 "git init"
          shell.capture3 "git add ."
          shell.capture3 %(git commit --all --no-verify --message "#{subject}" --message "#{body}")
        end
      end
    end
  end
end
