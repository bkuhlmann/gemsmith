module Gemsmith
  module Aids
    # Parses a raw string into a valid gem and/or class name which can be used to construct gem skeletons
    # and related Ruby objects.
    class Gem
      def initialize string = "unknown", util: Thor::Util
        @string = string
        @util = util
      end

      def name
        @name ||= util.snake_case(string).tr(" ", "_").tr "-", "_"
      end

      def klass
        @klass ||= util.camel_case name
      end

      private

      attr_reader :string, :util
    end
  end
end
