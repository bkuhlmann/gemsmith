# frozen_string_literal: true

module Gemsmith
  module Generators
    # Abstract class from which all skeletons inherit from.
    class Base
      def initialize cli, configuration: {}
        @cli = cli
        @configuration = configuration
      end

      def self.create cli, configuration: {}
        new(cli, configuration: configuration).create
      end

      def create
        fail NotImplementedError, "The method, #create, is not implemented yet."
      end

      protected

      attr_reader :cli, :configuration

      def lib_root
        File.join "%gem_name%", "lib"
      end

      def lib_gem_root
        File.join lib_root, "%gem_path%"
      end
    end
  end
end
