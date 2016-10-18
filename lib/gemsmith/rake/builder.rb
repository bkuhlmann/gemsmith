# frozen_string_literal: true

require "bundler/ui/shell"
require "tocer"

module Gemsmith
  module Rake
    # Provides gem build functionality. Meant to be wrapped in Rake tasks.
    class Builder
      def initialize tocer: Tocer::Writer, shell: Bundler::UI::Shell, kernel: Kernel
        @tocer = tocer
        @shell = shell.new
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

      private

      attr_reader :tocer, :shell, :kernel
    end
  end
end
