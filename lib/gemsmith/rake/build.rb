require "bundler/ui/shell"
require "tocer"

module Gemsmith
  module Rake
    # Provides gem build functionality. Meant to be wrapped in Rake tasks.
    class Build
      def initialize tocer: Tocer::Writer, shell: Bundler::UI::Shell
        @tocer = tocer
        @shell = shell.new
      end

      def doc
        readme = File.join Dir.pwd, "README.md"
        tocer.new(readme).write
        shell.info "Updated gem documentation."
      end

      def clean
        FileUtils.rm_rf "pkg"
        shell.info "Cleaned gem artifacts."
      end

      private

      attr_reader :tocer, :shell
    end
  end
end
