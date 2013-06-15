module Gemsmith
  module Skeletons
    class BaseSkeleton
      def initialize cli
        @cli = cli
      end

      def self.run cli
        self.new(cli).create
      end

      def create
        public_methods.each { |method| public_send(method) if method =~ /^create_.+$/ }
      end

      def respond_to? name, include_private = false
        @cli.respond_to?(name, include_private) || super(name, include_private)
      end

      def method_missing name, *args, &block
        if respond_to?(name)
          @cli.public_send name, *args, &block
        else
          super name, *args, &block
        end
      end

      private

      def gem_source_path
        File.join "lib", "gem"
      end

      def lib_install_path
        File.join install_path, "lib"
      end

      def gem_install_path
        File.join lib_install_path, gem_name
      end
    end
  end
end
