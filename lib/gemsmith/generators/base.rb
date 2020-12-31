# frozen_string_literal: true

require "pathname"

module Gemsmith
  module Generators
    # Abstract class from which all generators inherit from.
    class Base
      LIB_ROOT = Pathname("%gem_name%/lib").freeze
      LIB_ROOT_GEM = LIB_ROOT.join("%gem_path%").freeze

      def self.run cli, configuration: {}
        new(cli, configuration: configuration).run
      end

      def initialize cli, configuration: {}
        @cli = cli
        @configuration = configuration
      end

      def run
        fail NotImplementedError, "The method, #run, is not implemented yet."
      end

      protected

      attr_reader :cli, :configuration

      def gem_name
        configuration.dig :gem, :name
      end

      def gem_path
        configuration.dig :gem, :path
      end

      def gem_root
        Pathname(cli.destination_root).join gem_name
      end

      def template path
        cli.template path, configuration
      end
    end
  end
end
