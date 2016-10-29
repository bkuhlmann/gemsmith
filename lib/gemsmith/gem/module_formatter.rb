# frozen_string_literal: true

require "refinements/string_extensions"

module Gemsmith
  module Gem
    # Formats single or multiple modules with correct, two-space indentation for templates.
    class ModuleFormatter
      using Refinements::StringExtensions

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
          result + "#{indentation index}module #{module_name}\n"
        end
      end

      def body content
        indent = indentation depth + 1

        content.sub(/\A\n/, "").split("\n").reduce "" do |body, line|
          next "#{body}\n" if line.blank?
          body + "#{indent}#{line.gsub(/^\s{2}/, "")}\n"
        end
      end

      def suffix
        modules.each.with_index.reduce "" do |result, (_, index)|
          result + "#{indentation depth - index}end\n"
        end
      end

      def indentation length
        "  " * length
      end
    end
  end
end
