module Gemsmith
  module Skeletons
    # Abstract class from which all skeletons inherit from.
    class BaseSkeleton
      def initialize cli, configuration: Configuration.new
        @cli = cli
        @configuration = configuration
      end

      def self.create cli, configuration: Configuration.new
        new(cli, configuration: configuration).create
      end

      def create
        fail NotImplementedError, "The method, #create, is not implemented yet."
      end

      protected

      attr_reader :cli, :configuration

      def lib_root
        "%gem_name%/lib"
      end
    end
  end
end
