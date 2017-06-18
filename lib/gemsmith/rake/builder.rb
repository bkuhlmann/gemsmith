# frozen_string_literal: true

require "bundler/ui/shell"
require "fileutils"
require "tocer"

module Gemsmith
  module Rake
    # Provides gem build functionality. Meant to be wrapped in Rake tasks.
    class Builder
      def initialize tocer: Tocer::Writer, shell: Bundler::UI::Shell.new, kernel: Kernel
        @tocer = tocer
        @shell = shell
        @kernel = kernel
      end

      def doc
        readme = File.join Dir.pwd, "README.md"
        tocer.new(readme).write
        shell.confirm "Updated gem documentation."
      end

      def clean
        FileUtils.rm_rf "pkg"
        shell.confirm "Cleaned gem artifacts."
      end

      def validate
        return if `git status --porcelain`.empty?
        shell.error "Build failed: Gem has uncommitted changes."
        kernel.exit 1
      end

      def build gem_spec
        path = gem_spec.package_path

        if kernel.system("gem build #{gem_spec.name}.gemspec")
          FileUtils.mkdir_p "pkg"
          FileUtils.mv gem_spec.package_file_name, path
          shell.confirm "Built: #{path}."
        else
          shell.error "Unable to build: #{path}."
        end
      end

      def install gem_spec
        gem_name = "#{gem_spec.name} #{gem_spec.version_number}"

        if kernel.system("gem install #{gem_spec.package_path}")
          shell.confirm "Installed: #{gem_name}."
        else
          shell.error "Unable to install: #{gem_name}."
        end
      end

      private

      attr_reader :tocer, :shell, :kernel
    end
  end
end
