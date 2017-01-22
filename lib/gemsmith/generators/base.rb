# frozen_string_literal: true

module Gemsmith
  module Generators
    # Abstract class from which all generators inherit from.
    class Base
      def initialize cli, configuration: {}
        @cli = cli
        @configuration = configuration
      end

      def self.run cli, configuration: {}
        new(cli, configuration: configuration).run
      end

      def run
        fail NotImplementedError, "The method, #run, is not implemented yet."
      end

      protected

      attr_reader :cli, :configuration

      def lib_root
        File.join "%gem_name%", "lib"
      end

      def lib_gem_root
        File.join lib_root, "%gem_path%"
      end

      def gem_name
        configuration.dig :gem, :name
      end

      def gem_path
        configuration.dig :gem, :path
      end
    end
  end
end
