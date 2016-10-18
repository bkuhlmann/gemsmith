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

      # def build_gem
      #   file_name = nil
      #   sh("gem build -V '#{spec_path}'") do
      #     file_name = File.basename(built_gem_path)
      #     SharedHelpers.filesystem_access(File.join(base, "pkg")) {|p| FileUtils.mkdir_p(p) }
      #     FileUtils.mv(built_gem_path, "pkg")
      #     Bundler.ui.confirm "#{name} #{version} built to pkg/#{file_name}."
      #   end
      #   File.join(base, "pkg", file_name)
      # end


      # def install_gem(built_gem_path = nil, local = false)
      #   built_gem_path ||= build_gem
      #   out, _ = sh_with_code("gem install '#{built_gem_path}'#{" --local" if local}")
      #   raise "Couldn't install gem, run `gem install #{built_gem_path}' for more detailed output" unless out[/Successfully installed/]
      #   Bundler.ui.confirm "#{name} (#{version}) installed."
      # end

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
