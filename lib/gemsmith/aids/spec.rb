require "open3"

module Gemsmith
  module Aids
    # A convenience aid to the Gem::Specification object.
    class Spec
      def initialize specification: ::Gem::Specification, shell: Open3
        @specification = specification
        @shell = shell
      end

      def editor
        ENV["EDITOR"]
      end

      def open spec = nil
        return unless spec
        shell.capture2 editor, spec.full_gem_path
        spec.full_gem_path
      end

      def read spec = nil
        return unless spec
        return if spec.homepage.nil? || spec.homepage.empty?

        shell.capture2 "open", spec.homepage
        spec.homepage
      end

      def find name, version
        specification.find_by_name name, version
      end

      def find_all name
        specification.find_all_by_name name
      end

      private

      attr_reader :specification, :shell
    end
  end
end
