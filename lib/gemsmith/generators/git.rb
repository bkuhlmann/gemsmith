# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Git support.
    class Git < Base
      def create_ignore_file
        cli.template "%gem_name%/.gitignore.tt", configuration
      end

      def create_repository
        Dir.chdir(gem_dir) do
          `git init`
          `git add .`
          `git commit --all --no-verify --message "Added Gemsmith files."`
        end
      end

      def run
        create_ignore_file
        create_repository
      end

      private

      def gem_dir
        File.join cli.destination_root, configuration.dig(:gem, :name)
      end
    end
  end
end
