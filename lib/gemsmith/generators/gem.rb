# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates default gem support.
    class Gem < Base
      def run
        create_binaries
        create_skeleton
      end

      private

      def create_binaries
        template "%gem_name%/bin/console.tt"
        template "%gem_name%/bin/setup.tt"
        cli.chmod "#{gem_name}/bin/console", 0o755
        cli.chmod "#{gem_name}/bin/setup", 0o755
      end

      def create_skeleton
        template "%gem_name%/Gemfile.tt"
        template "%gem_name%/%gem_name%.gemspec.tt"
        template "#{LIB_ROOT_GEM}.rb.tt"
        template "#{LIB_ROOT_GEM}/identity.rb.tt"
      end
    end
  end
end
