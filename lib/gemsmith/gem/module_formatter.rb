# frozen_string_literal: true

require "refinements/strings"

module Gemsmith
  module Gem
    # Formats single or multiple modules with correct, two-space indentation for templates.
    class ModuleFormatter
      using Refinements::Strings

      def self.indent length = 0
        "  " * length
      end

      def initialize namespace
        @namespace = namespace
        @modules = namespace.split "::"
        @depth = namespace.scan("::").length
      end

      def render content
        "#{prefix}#{body content}#{suffix.chomp}"
      end

      private

      attr_reader :namespace, :modules, :depth

      def prefix
        modules.each.with_index.reduce "" do |result, (module_name, index)|
          result + "#{self.class.indent index}module #{module_name}\n"
        end
      end

      def body content
        content.sub(/\A\n/, "").split("\n").reduce "" do |body, line|
          next "#{body}\n" if line.blank?
          body + "#{self.class.indent depth + 1}#{line.gsub(/^\s{2}/, "")}\n"
        end
      end

      def suffix
        modules.each.with_index.reduce "" do |result, (_, index)|
          result + "#{self.class.indent depth - index}end\n"
        end
      end
    end
  end
end
