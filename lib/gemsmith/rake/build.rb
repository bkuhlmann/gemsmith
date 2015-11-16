require "bundler/ui/shell"
require "tocer"

module Gemsmith
  module Rake
    # Provides gem build functionality. Meant to be wrapped in Rake tasks.
    class Build
      def initialize tocer: Tocer::Writer, shell: Bundler::UI::Shell, kernel: Kernel
        @tocer = tocer
        @shell = shell.new
        @kernel = kernel
      end

      def doc
        readme = File.join Dir.pwd, "README.md"
        tocer.new(readme).write
        shell.info "Updated gem documentation."
      end

      def table_of_contents
        if kernel.system("command -v doctoc > /dev/null")
          kernel.system %(doctoc --title "# Table of Contents" README.md)
        else
          shell.error error_message
          kernel.exit 1
        end
      end

      def clean!
        FileUtils.rm_rf "pkg"
        shell.info "Gem artifacts cleaned."
      end

      private

      attr_reader :tocer, :shell, :kernel

      def error_message
        url = "https://github.com/thlorenz/doctoc"
        command = "npm install --global doctoc"

        "Unable to update README Table of Contents, please install DocToc (#{url}): #{command}."
      end
    end
  end
end
