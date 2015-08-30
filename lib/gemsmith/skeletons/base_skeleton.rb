module Gemsmith
  module Skeletons
    # Abstract class from which all skeletons inherit from.
    class BaseSkeleton
      def initialize cli
        @cli = cli
      end

      def self.create cli
        new(cli).create
      end

      def create
        fail NotImplementedError, "The method, #create, is not implemented yet."
      end

      private

      attr_reader :cli

      def lib_root
        "%gem_name%/lib"
      end
    end
  end
end
