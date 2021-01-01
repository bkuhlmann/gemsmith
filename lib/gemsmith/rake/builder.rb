# frozen_string_literal: true

require "bundler/ui/shell"
require "refinements/pathnames"

module Gemsmith
  module Rake
    # Provides gem build functionality. Meant to be wrapped in Rake tasks.
    class Builder
      using Refinements::Pathnames

      def initialize root: Pathname("pkg"), shell: Bundler::UI::Shell.new, kernel: Kernel
        @root = root
        @shell = shell
        @kernel = kernel
      end

      def clean
        root.remove_tree
        shell.confirm "Cleaned gem artifacts."
      end

      def validate
        return if `git status --porcelain`.empty?

        shell.error "Build failed: Gem has uncommitted changes."
        kernel.exit 1
      end

      def build gem_spec
        path = gem_spec.package_path

        if kernel.system "gem build #{gem_spec.name}.gemspec"
          root.make_path
          Pathname(gem_spec.package_file_name).copy path
          shell.confirm "Built: #{path}."
        else
          shell.error "Unable to build: #{path}."
        end
      end

      def install gem_spec
        gem_name = "#{gem_spec.name} #{gem_spec.version}"

        if kernel.system "gem install #{gem_spec.package_path}"
          shell.confirm "Installed: #{gem_name}."
        else
          shell.error "Unable to install: #{gem_name}."
        end
      end

      private

      attr_reader :root, :shell, :kernel
    end
  end
end
