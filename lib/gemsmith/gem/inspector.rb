# frozen_string_literal: true

require "open3"

module Gemsmith
  module Gem
    # Provides the ability to investigate a gem in greater detail.
    class Inspector
      def self.editor
        ENV.fetch "EDITOR"
      end

      def initialize shell: Open3
        @shell = shell
      end

      def edit specification
        shell.capture2 self.class.editor, specification.path
      end

      def visit specification
        shell.capture2 "open", specification.homepage_url
      end

      private

      attr_reader :shell
    end
  end
end
