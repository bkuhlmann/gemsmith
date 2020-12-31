# frozen_string_literal: true

require "open3"
require "refinements/pathnames"

module Gemsmith
  module Generators
    # Generates Git support.
    class Git < Base
      using Refinements::Pathnames

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
        create_commit "Added gem skeleton",
                      "Generated with [#{Identity::LABEL}](#{Identity::URL})\n" \
                      "#{Identity::VERSION}."
      end

      def create_commit subject, body
        gem_root.change_dir do
          shell.capture3 "git init"
          shell.capture3 "git add ."
          shell.capture3 %(git commit --all --no-verify --message "#{subject}" --message "#{body}")
        end
      end
    end
  end
end
